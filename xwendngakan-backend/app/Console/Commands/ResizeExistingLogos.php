<?php

namespace App\Console\Commands;

use App\Models\Institution;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Laravel\Facades\Image;

class ResizeExistingLogos extends Command
{
    protected $signature = 'institutions:resize-logos';
    protected $description = 'Resize all existing logos to 400x400 uniform size';

    public function handle(): int
    {
        // Increase memory for large images
        ini_set('memory_limit', '512M');

        $institutions = Institution::whereNotNull('logo')
            ->where('logo', '!=', '')
            ->get();

        $this->info("Processing {$institutions->count()} logos...");
        $bar = $this->output->createProgressBar($institutions->count());
        $bar->start();

        $resized = 0;
        $skipped = 0;

        foreach ($institutions as $inst) {
            $file = $inst->logo;

            if (! Storage::disk('public')->exists($file)) {
                $skipped++;
                $bar->advance();
                continue;
            }

            try {
                $data = Storage::disk('public')->get($file);
                $img = Image::read($data);

                // Skip if already 400x400
                if ($img->width() === 400 && $img->height() === 400) {
                    $skipped++;
                    $bar->advance();
                    continue;
                }

                $resizedImg = $img->contain(400, 400)->toPng();

                $newName = pathinfo($file, PATHINFO_DIRNAME) . '/' . pathinfo($file, PATHINFO_FILENAME) . '.png';
                Storage::disk('public')->put($newName, (string) $resizedImg);

                // Delete old file if different name
                if ($newName !== $file) {
                    Storage::disk('public')->delete($file);
                }

                $inst->update(['logo' => $newName]);
                $resized++;
            } catch (\Exception $e) {
                $this->newLine();
                $this->warn("  Error [{$inst->nen}]: " . $e->getMessage());
            }

            $bar->advance();
        }

        $bar->finish();
        $this->newLine(2);
        $this->info("Done! Resized: {$resized}, Skipped: {$skipped}");

        return 0;
    }
}
