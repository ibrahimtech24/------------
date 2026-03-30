<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use App\Models\Institution;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    /**
     * Get user's favorite institutions.
     */
    public function index(Request $request)
    {
        $favorites = $request->user()
            ->favoriteInstitutions()
            ->where('approved', true)
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $favorites,
        ]);
    }

    /**
     * Get favorite IDs only (for quick sync).
     */
    public function ids(Request $request)
    {
        $ids = $request->user()
            ->favorites()
            ->pluck('institution_id');

        return response()->json([
            'success' => true,
            'data'    => $ids,
        ]);
    }

    /**
     * Add an institution to favorites.
     */
    public function store(Request $request, int $institutionId)
    {
        $institution = Institution::findOrFail($institutionId);

        // Check if already favorited
        if ($request->user()->hasFavorited($institutionId)) {
            return response()->json([
                'success' => false,
                'message' => 'پێشتر زیادکراوە بۆ دڵخوازەکان.',
            ], 400);
        }

        $request->user()->favorites()->create([
            'institution_id' => $institutionId,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'زیادکرا بۆ دڵخوازەکان.',
        ], 201);
    }

    /**
     * Remove an institution from favorites.
     */
    public function destroy(Request $request, int $institutionId)
    {
        $deleted = $request->user()
            ->favorites()
            ->where('institution_id', $institutionId)
            ->delete();

        if (!$deleted) {
            return response()->json([
                'success' => false,
                'message' => 'لە دڵخوازەکاندا نەبوو.',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'لابرا لە دڵخوازەکان.',
        ]);
    }

    /**
     * Toggle favorite status.
     */
    public function toggle(Request $request, int $institutionId)
    {
        Institution::findOrFail($institutionId);

        $favorite = $request->user()
            ->favorites()
            ->where('institution_id', $institutionId)
            ->first();

        if ($favorite) {
            $favorite->delete();
            return response()->json([
                'success' => true,
                'favorited' => false,
                'message' => 'لابرا لە دڵخوازەکان.',
            ]);
        }

        $request->user()->favorites()->create([
            'institution_id' => $institutionId,
        ]);

        return response()->json([
            'success' => true,
            'favorited' => true,
            'message' => 'زیادکرا بۆ دڵخوازەکان.',
        ]);
    }
}
