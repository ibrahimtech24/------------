<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Institution;
use App\Models\Report;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    /**
     * Submit a report for an institution.
     */
    public function store(Request $request, int $institutionId)
    {
        $request->validate([
            'type'        => 'required|string|in:incorrect_info,closed,duplicate,spam,other',
            'description' => 'nullable|string|max:1000',
        ]);

        Institution::findOrFail($institutionId);

        $report = Report::create([
            'institution_id' => $institutionId,
            'user_id'        => $request->user()?->id,
            'type'           => $request->type,
            'description'    => $request->description,
            'status'         => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'سوپاس بۆ ڕاپۆرتەکەت. بەم زووانە پشکنین دەکرێت.',
            'data'    => $report,
        ], 201);
    }

    /**
     * Get report types for dropdown.
     */
    public function types()
    {
        return response()->json([
            'success' => true,
            'data'    => [
                ['key' => 'incorrect_info', 'name' => 'زانیاری هەڵە', 'name_en' => 'Incorrect Information', 'name_ar' => 'معلومات خاطئة'],
                ['key' => 'closed', 'name' => 'داخراوە', 'name_en' => 'Closed/No longer exists', 'name_ar' => 'مغلق'],
                ['key' => 'duplicate', 'name' => 'دووبارەیە', 'name_en' => 'Duplicate', 'name_ar' => 'مكرر'],
                ['key' => 'spam', 'name' => 'سپام', 'name_en' => 'Spam', 'name_ar' => 'بريد غير مرغوب'],
                ['key' => 'other', 'name' => 'هۆکاری تر', 'name_en' => 'Other', 'name_ar' => 'أخرى'],
            ],
        ]);
    }
}
