<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Institution extends Model
{
    protected $fillable = [
        'nku', 'nen', 'nar', 'type', 'country', 'city',
        'web', 'phone', 'email', 'addr', 'desc',
        'lat', 'lng',
        'colleges', 'depts',
        'fee', 'meal', 'uniform', 'books', 'level',
        'kg_fee', 'kg_meal', 'kg_uniform', 'kg_age', 'kg_hours',
        'fb', 'ig', 'tg', 'wa', 'tk', 'yt',
        'logo', 'img', 'approved',
    ];

    protected $casts = [
        'approved' => 'boolean',
        'lat' => 'double',
        'lng' => 'double',
    ];

    // Map snake_case DB columns to camelCase for Flutter JSON
    public function toArray()
    {
        $array = parent::toArray();
        $array['kgAge'] = $array['kg_age'] ?? '';
        $array['kgHours'] = $array['kg_hours'] ?? '';
        unset($array['kg_fee'], $array['kg_meal'], $array['kg_uniform'], $array['kg_age'], $array['kg_hours']);
        unset($array['fee'], $array['meal'], $array['uniform'], $array['books'], $array['level'], $array['kg_fee'], $array['kg_meal'], $array['kg_uniform']);

        // Ensure logo path starts with /storage/ for API consumers
        if (!empty($array['logo']) && !str_starts_with($array['logo'], 'http') && !str_starts_with($array['logo'], '/storage/')) {
            $array['logo'] = '/storage/' . ltrim($array['logo'], '/');
        }

        return $array;
    }

    /**
     * Get posts for this institution.
     */
    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }
}
