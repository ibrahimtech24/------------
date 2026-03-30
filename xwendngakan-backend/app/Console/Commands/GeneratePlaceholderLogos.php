<?php

namespace App\Console\Commands;

use App\Models\Institution;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class GeneratePlaceholderLogos extends Command
{
    protected $signature = 'institutions:generate-logos {--force : Overwrite existing logos}';
    protected $description = 'Generate PNG placeholder logos for institutions without logos';

    private array $typeColors = [
        'gov'      => [[26, 82, 118],  [41, 128, 185]],
        'priv'     => [[123, 36, 28],  [192, 57, 43]],
        'inst5'    => [[30, 132, 73],  [39, 174, 96]],
        'inst2'    => [[108, 52, 131], [142, 68, 173]],
        'school'   => [[185, 119, 14], [243, 156, 18]],
        'kg'       => [[211, 84, 0],   [230, 126, 34]],
        'dc'       => [[192, 57, 43],  [231, 76, 60]],
        'lang'     => [[36, 113, 163], [52, 152, 219]],
        'edu'      => [[17, 122, 101], [26, 188, 156]],
        'eve_uni'  => [[31, 97, 141],  [46, 134, 193]],
        'eve_inst' => [[91, 44, 111],  [125, 60, 152]],
    ];

    public function handle(): int
    {
        $query = Institution::query();

        if (! $this->option('force')) {
            $query->where(function ($q) {
                $q->whereNull('logo')
                  ->orWhere('logo', '')
                  ->orWhere('logo', 'like', '%-placeholder.svg');
            });
        }

        $institutions = $query->get();

        if ($institutions->isEmpty()) {
            $this->info('All institutions already have logos.');
            return 0;
        }

        $this->info("Generating placeholder logos for {$institutions->count()} institutions...");
        $bar = $this->output->createProgressBar($institutions->count());
        $bar->start();

        foreach ($institutions as $inst) {
            $initials = $this->getInitials($inst);
            $colors = $this->typeColors[$inst->type] ?? [[44, 62, 80], [52, 73, 94]];

            $pngData = $this->generatePng($initials, $colors[0], $colors[1]);
            $filename = 'logos/' . Str::slug($inst->nen ?: $inst->nku) . '-placeholder.png';

            Storage::disk('public')->put($filename, $pngData);

            // Delete old SVG placeholder if exists
            $oldSvg = str_replace('.png', '.svg', $filename);
            if (Storage::disk('public')->exists($oldSvg)) {
                Storage::disk('public')->delete($oldSvg);
            }

            $inst->update(['logo' => $filename]);

            $bar->advance();
        }

        $bar->finish();
        $this->newLine(2);
        $this->info("Done! Generated {$institutions->count()} placeholder logos.");

        return 0;
    }

    private function getInitials(Institution $inst): string
    {
        $name = $inst->nen ?: $inst->nku;

        if (empty($name)) {
            return '?';
        }

        if (preg_match('/^[a-zA-Z]/', $name)) {
            $words = explode(' ', $name);
            $skip = ['of', 'the', 'and', 'in', 'for', '-'];
            $letters = [];
            foreach ($words as $w) {
                if (! in_array(strtolower($w), $skip) && strlen($w) > 0) {
                    $letters[] = strtoupper($w[0]);
                }
                if (count($letters) >= 3) break;
            }
            return implode('', $letters);
        }

        $chars = mb_str_split($name);
        $result = '';
        $count = 0;
        foreach ($chars as $ch) {
            if ($ch !== ' ' && $count < 2) {
                $result .= $ch;
                $count++;
            }
        }
        return $result;
    }

    private function generatePng(string $initials, array $color1, array $color2): string
    {
        $size = 400;
        $img = imagecreatetruecolor($size, $size);
        imagesavealpha($img, true);

        // Draw gradient background
        for ($y = 0; $y < $size; $y++) {
            $ratio = $y / $size;
            $r = (int) ($color1[0] + ($color2[0] - $color1[0]) * $ratio);
            $g = (int) ($color1[1] + ($color2[1] - $color1[1]) * $ratio);
            $b = (int) ($color1[2] + ($color2[2] - $color1[2]) * $ratio);
            $lineColor = imagecolorallocate($img, $r, $g, $b);
            imageline($img, 0, $y, $size - 1, $y, $lineColor);
        }

        // Draw initials text
        $white = imagecolorallocate($img, 255, 255, 255);
        $fontSize = mb_strlen($initials) > 2 ? 80 : 100;

        // Use built-in GD font (large)
        $fontWidth = imagefontwidth(5) * strlen($initials);
        $fontHeight = imagefontheight(5);

        // Scale up with larger text using imagestring for ASCII, or TTF if available
        $fontFile = '/System/Library/Fonts/Helvetica.ttc';
        if (file_exists($fontFile)) {
            $bbox = imagettfbbox($fontSize, 0, $fontFile, $initials);
            $textWidth = abs($bbox[2] - $bbox[0]);
            $textHeight = abs($bbox[7] - $bbox[1]);
            $x = ($size - $textWidth) / 2 - $bbox[0];
            $y = ($size + $textHeight) / 2 - $bbox[1] - $textHeight;
            imagettftext($img, $fontSize, 0, (int) $x, (int) $y, $white, $fontFile, $initials);
        } else {
            // Fallback: basic GD font centered
            $x = ($size - $fontWidth) / 2;
            $y = ($size - $fontHeight) / 2;
            imagestring($img, 5, (int) $x, (int) $y, $initials, $white);
        }

        ob_start();
        imagepng($img);
        $pngData = ob_get_clean();
        imagedestroy($img);

        return $pngData;
    }
}
