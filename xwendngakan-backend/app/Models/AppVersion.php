<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AppVersion extends Model
{
    protected $fillable = [
        'platform',
        'version',
        'build_number',
        'force_update',
        'store_url',
        'release_notes',
        'release_notes_en',
        'release_notes_ar',
    ];

    protected $casts = [
        'force_update' => 'boolean',
        'build_number' => 'integer',
    ];

    public const PLATFORM_ANDROID = 'android';
    public const PLATFORM_IOS = 'ios';

    /**
     * Get the latest version for a platform.
     */
    public static function getLatest(string $platform): ?self
    {
        return self::where('platform', $platform)
            ->orderByDesc('build_number')
            ->first();
    }

    /**
     * Check if an update is required for the given build number.
     */
    public function requiresUpdate(int $currentBuild): bool
    {
        return $this->build_number > $currentBuild;
    }

    /**
     * Check if a force update is required for the given build number.
     */
    public function requiresForceUpdate(int $currentBuild): bool
    {
        return $this->force_update && $this->build_number > $currentBuild;
    }
}
