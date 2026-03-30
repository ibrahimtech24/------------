<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('institution_types', function (Blueprint $table) {
            $table->string('icon')->nullable()->after('emoji');
        });

        // Set default icons for existing types
        $icons = [
            'gov' => 'teacher',
            'priv' => 'building_4',
            'inst5' => 'book_1',
            'inst2' => 'bookmark_2',
            'school' => 'house',
            'kg' => 'happyemoji',
            'dc' => 'heart',
            'lang' => 'translate',
            'edu' => 'buildings',
            'eve_uni' => 'moon',
            'eve_inst' => 'lamp',
        ];
        foreach ($icons as $key => $icon) {
            DB::table('institution_types')->where('key', $key)->update(['icon' => $icon]);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('institution_types', function (Blueprint $table) {
            $table->dropColumn('icon');
        });
    }
};
