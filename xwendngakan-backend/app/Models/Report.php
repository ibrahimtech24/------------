<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Report extends Model
{
    protected $fillable = [
        'institution_id',
        'user_id',
        'type',
        'description',
        'status',
        'admin_notes',
    ];

    public function institution(): BelongsTo
    {
        return $this->belongsTo(Institution::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Report types
    public const TYPE_INCORRECT_INFO = 'incorrect_info';
    public const TYPE_CLOSED = 'closed';
    public const TYPE_DUPLICATE = 'duplicate';
    public const TYPE_SPAM = 'spam';
    public const TYPE_OTHER = 'other';

    public static function types(): array
    {
        return [
            self::TYPE_INCORRECT_INFO => 'زانیاری هەڵە',
            self::TYPE_CLOSED => 'داخراوە',
            self::TYPE_DUPLICATE => 'دووبارەیە',
            self::TYPE_SPAM => 'سپام',
            self::TYPE_OTHER => 'هۆکاری تر',
        ];
    }
}
