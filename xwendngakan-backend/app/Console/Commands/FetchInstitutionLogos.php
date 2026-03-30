<?php

namespace App\Console\Commands;

use App\Models\Institution;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class FetchInstitutionLogos extends Command
{
    protected $signature = 'institutions:fetch-logos {--force : Overwrite existing logos}';
    protected $description = 'Fetch logos from institution websites and store them locally';

    public function handle(): int
    {
        $query = Institution::whereNotNull('web')->where('web', '!=', '');

        if (! $this->option('force')) {
            $query->where(function ($q) {
                $q->whereNull('logo')->orWhere('logo', '');
            });
        }

        $institutions = $query->get();

        if ($institutions->isEmpty()) {
            $this->info('No institutions need logos.');
            return 0;
        }

        $this->info("Fetching logos for {$institutions->count()} institutions...");
        $bar = $this->output->createProgressBar($institutions->count());
        $bar->start();

        $success = 0;
        $failed = 0;

        foreach ($institutions as $inst) {
            $domain = $this->extractDomain($inst->web);
            if (! $domain) {
                $this->newLine();
                $this->warn("  Skipped [{$inst->nen}]: invalid URL");
                $failed++;
                $bar->advance();
                continue;
            }

            $imageData = $this->tryFetchLogo($inst->web, $domain);

            if ($imageData) {
                $ext = $this->detectExtension($imageData);
                $filename = 'logos/' . Str::slug($inst->nen ?: $inst->nku) . '.' . $ext;

                Storage::disk('public')->put($filename, $imageData);
                $inst->update(['logo' => $filename]);
                $success++;
            } else {
                $this->newLine();
                $this->warn("  Failed [{$inst->nen}]: could not fetch logo from {$domain}");
                $failed++;
            }

            $bar->advance();
        }

        $bar->finish();
        $this->newLine(2);
        $this->info("Done! Success: {$success}, Failed: {$failed}");

        return 0;
    }

    private function extractDomain(string $url): ?string
    {
        $parsed = parse_url($url);
        return $parsed['host'] ?? null;
    }

    /**
     * Try multiple strategies to get a logo image.
     */
    private function tryFetchLogo(string $webUrl, string $domain): ?string
    {
        // Strategy 1: Parse the website HTML for og:image or apple-touch-icon
        $fromHtml = $this->fetchLogoFromHtml($webUrl);
        if ($fromHtml) {
            return $fromHtml;
        }

        // Strategy 2: Try common logo paths
        $commonPaths = [
            '/apple-touch-icon.png',
            '/apple-touch-icon-precomposed.png',
            '/favicon-192x192.png',
            '/android-chrome-192x192.png',
            '/android-chrome-512x512.png',
            '/logo.png',
            '/images/logo.png',
            '/img/logo.png',
            '/assets/images/logo.png',
        ];

        $baseUrl = rtrim($webUrl, '/');
        foreach ($commonPaths as $path) {
            $data = $this->downloadImage($baseUrl . $path);
            if ($data && strlen($data) > 1000) { // ensure it's not a tiny placeholder
                return $data;
            }
        }

        // Strategy 3: Google's favicon API (128px)
        $googleUrl = "https://www.google.com/s2/favicons?sz=128&domain={$domain}";
        $data = $this->downloadImage($googleUrl);
        if ($data && strlen($data) > 500) {
            return $data;
        }

        return null;
    }

    /**
     * Parse HTML to find og:image, apple-touch-icon, or large favicon.
     */
    private function fetchLogoFromHtml(string $url): ?string
    {
        try {
            $response = Http::timeout(10)
                ->withOptions(['verify' => false])
                ->get($url);

            if (! $response->successful()) {
                return null;
            }

            $html = $response->body();
            $baseUrl = rtrim($url, '/');

            // Try og:image first (usually highest quality)
            if (preg_match('/<meta\s+(?:property|name)=["\']og:image["\']\s+content=["\']([^"\']+)["\']/i', $html, $m)) {
                $imgUrl = $this->resolveRelativeUrl($m[1], $baseUrl);
                $data = $this->downloadImage($imgUrl);
                if ($data && strlen($data) > 2000) {
                    return $data;
                }
            }

            // Also check content-first variant
            if (preg_match('/<meta\s+content=["\']([^"\']+)["\']\s+(?:property|name)=["\']og:image["\']/i', $html, $m)) {
                $imgUrl = $this->resolveRelativeUrl($m[1], $baseUrl);
                $data = $this->downloadImage($imgUrl);
                if ($data && strlen($data) > 2000) {
                    return $data;
                }
            }

            // Try apple-touch-icon (usually 180x180 or larger)
            if (preg_match('/<link[^>]+rel=["\']apple-touch-icon["\'][^>]+href=["\']([^"\']+)["\']/i', $html, $m)) {
                $imgUrl = $this->resolveRelativeUrl($m[1], $baseUrl);
                $data = $this->downloadImage($imgUrl);
                if ($data && strlen($data) > 1000) {
                    return $data;
                }
            }

            // Try large favicon links
            if (preg_match_all('/<link[^>]+rel=["\']icon["\'][^>]+href=["\']([^"\']+)["\']/i', $html, $matches)) {
                foreach ($matches[1] as $iconUrl) {
                    $imgUrl = $this->resolveRelativeUrl($iconUrl, $baseUrl);
                    $data = $this->downloadImage($imgUrl);
                    if ($data && strlen($data) > 2000) {
                        return $data;
                    }
                }
            }

        } catch (\Exception $e) {
            // Silently fail, will try other strategies
        }

        return null;
    }

    private function resolveRelativeUrl(string $imgUrl, string $baseUrl): string
    {
        if (str_starts_with($imgUrl, 'http')) {
            return $imgUrl;
        }

        $parsed = parse_url($baseUrl);
        $origin = ($parsed['scheme'] ?? 'https') . '://' . ($parsed['host'] ?? '');

        if (str_starts_with($imgUrl, '//')) {
            return ($parsed['scheme'] ?? 'https') . ':' . $imgUrl;
        }

        if (str_starts_with($imgUrl, '/')) {
            return $origin . $imgUrl;
        }

        return $origin . '/' . $imgUrl;
    }

    private function downloadImage(string $url): ?string
    {
        try {
            $response = Http::timeout(8)
                ->withOptions(['verify' => false])
                ->get($url);

            if ($response->successful()) {
                $contentType = $response->header('Content-Type');
                if ($contentType && str_contains($contentType, 'image')) {
                    return $response->body();
                }
                // Check if it looks like image data even without proper content-type
                $body = $response->body();
                if ($this->looksLikeImage($body)) {
                    return $body;
                }
            }
        } catch (\Exception $e) {
            // Silently fail
        }

        return null;
    }

    private function looksLikeImage(string $data): bool
    {
        if (strlen($data) < 100) return false;
        // Check magic bytes for PNG, JPEG, GIF, WEBP, ICO, SVG
        return str_starts_with($data, "\x89PNG")
            || str_starts_with($data, "\xFF\xD8\xFF")
            || str_starts_with($data, "GIF8")
            || str_starts_with($data, "RIFF")
            || str_starts_with($data, "\x00\x00\x01\x00")
            || str_starts_with($data, '<svg')
            || str_starts_with($data, '<?xml');
    }

    private function detectExtension(string $data): string
    {
        if (str_starts_with($data, "\x89PNG")) return 'png';
        if (str_starts_with($data, "\xFF\xD8\xFF")) return 'jpg';
        if (str_starts_with($data, "GIF8")) return 'gif';
        if (str_starts_with($data, "RIFF")) return 'webp';
        if (str_starts_with($data, '<svg') || str_starts_with($data, '<?xml')) return 'svg';
        return 'png'; // default
    }
}
