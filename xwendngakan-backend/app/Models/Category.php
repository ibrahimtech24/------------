<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class Category extends Model
{
    protected static function booted(): void
    {
        static::creating(function (Category $category) {
            if (empty($category->key)) {
                $base = Str::slug($category->name, '_');
                if (empty($base)) {
                    $base = 'cat_' . Str::random(6);
                }
                $key = $base;
                $i = 1;
                while (Category::where('key', $key)->exists()) {
                    $key = $base . '_' . $i++;
                }
                $category->key = $key;
            }
        });
    }

    protected $fillable = [
        'key',
        'name',
        'name_en',
        'name_ar',
        'icon',
        'parent_key',
        'sort_order',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'sort_order' => 'integer',
    ];

    /**
     * Get parent category.
     */
    public function parent(): BelongsTo
    {
        return $this->belongsTo(Category::class, 'parent_key', 'key');
    }

    /**
     * Get child categories.
     */
    public function children(): HasMany
    {
        return $this->hasMany(Category::class, 'parent_key', 'key');
    }

    /**
     * Get only main categories (no parent).
     */
    public function scopeMain($query)
    {
        return $query->whereNull('parent_key');
    }

    /**
     * Get only active categories.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Get ordered categories.
     */
    public function scopeOrdered($query)
    {
        return $query->orderBy('sort_order');
    }
}
