<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class QuickStat extends Model
{
    protected $fillable = [
        'key',
        'label',
        'icon',
        'color',
        'count_type',
        'count_value',
        'sort_order',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'sort_order' => 'integer',
    ];

    /**
     * Get only active stats.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Get ordered stats.
     */
    public function scopeOrdered($query)
    {
        return $query->orderBy('sort_order');
    }

    /**
     * Calculate count based on type.
     */
    public function getCountAttribute(): int
    {
        if ($this->count_type === 'custom') {
            return (int) $this->count_value;
        }

        // Count by institution types
        $types = explode(',', $this->count_value);
        return Institution::where('approved', true)
            ->whereIn('type', $types)
            ->count();
    }
}
