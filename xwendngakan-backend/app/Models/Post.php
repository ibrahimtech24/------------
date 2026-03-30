<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Post extends Model
{
    protected $fillable = [
        'institution_id',
        'user_id',
        'title',
        'content',
        'image',
        'approved',
    ];

    protected $casts = [
        'approved' => 'boolean',
    ];

    /**
     * The institution this post belongs to.
     */
    public function institution(): BelongsTo
    {
        return $this->belongsTo(Institution::class);
    }

    /**
     * The user who created this post.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Convert to array with Flutter-friendly keys.
     */
    public function toArray()
    {
        $array = parent::toArray();

        // Add author name from user relation
        $array['author_name'] = $this->user?->name ?? '';

        // Add institution name for admin view
        $array['institution_name'] = $this->institution?->nku ?? '';

        // Ensure image path starts with /storage/ for API consumers
        if (!empty($array['image']) && !str_starts_with($array['image'], 'http') && !str_starts_with($array['image'], '/storage/')) {
            $array['image'] = '/storage/' . ltrim($array['image'], '/');
        }

        return $array;
    }
}
