<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AppVersion;
use Illuminate\Http\Request;

class AppVersionController extends Controller
{
    /**
     * Check for app updates.
     */
    public function check(Request $request)
    {
        $request->validate([
            'platform' => 'required|string|in:android,ios',
            'build'    => 'required|integer',
        ]);

        $platform = $request->platform;
        $currentBuild = $request->build;

        $latest = AppVersion::getLatest($platform);

        if (!$latest) {
            return response()->json([
                'success' => true,
                'data'    => [
                    'update_available' => false,
                    'force_update'     => false,
                ],
            ]);
        }

        $updateAvailable = $latest->requiresUpdate($currentBuild);
        $forceUpdate = $latest->requiresForceUpdate($currentBuild);

        return response()->json([
            'success' => true,
            'data'    => [
                'update_available' => $updateAvailable,
                'force_update'     => $forceUpdate,
                'latest_version'   => $latest->version,
                'latest_build'     => $latest->build_number,
                'store_url'        => $latest->store_url,
                'release_notes'    => $latest->release_notes,
                'release_notes_en' => $latest->release_notes_en,
                'release_notes_ar' => $latest->release_notes_ar,
            ],
        ]);
    }
}
