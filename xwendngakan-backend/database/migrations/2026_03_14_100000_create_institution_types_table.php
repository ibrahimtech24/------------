<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('institution_types', function (Blueprint $table) {
            $table->id();
            $table->string('key')->unique();       // gov, priv, inst5, ...
            $table->string('name');                 // ناوی کوردی
            $table->string('emoji')->nullable();    // 🎓
            $table->integer('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Seed default types
        DB::table('institution_types')->insert([
            ['key' => 'gov',    'name' => 'زانکۆ حکومی',         'emoji' => '🎓', 'sort_order' => 1, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'priv',   'name' => 'زانکۆ تایبەت',        'emoji' => '🏛️', 'sort_order' => 2, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'inst5',  'name' => 'پەیمانگەی ٥ ساڵی',   'emoji' => '📘', 'sort_order' => 3, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'inst2',  'name' => 'پەیمانگەی ٢ ساڵی',   'emoji' => '📗', 'sort_order' => 4, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'school', 'name' => 'قوتابخانە',           'emoji' => '🏫', 'sort_order' => 5, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'kg',     'name' => 'باخچەی منداڵان',      'emoji' => '🧒', 'sort_order' => 6, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'dc',     'name' => 'دایەنگە',             'emoji' => '👶', 'sort_order' => 7, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'lang',   'name' => 'سەنتەری زمان/پیشەیی', 'emoji' => '📖', 'sort_order' => 8, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'edu',    'name' => 'کۆمەڵکای پەروەردەیی', 'emoji' => '🏢', 'sort_order' => 9, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'eve_uni',  'name' => 'زانکۆی ئێواران',    'emoji' => '🌙', 'sort_order' => 10, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'eve_inst', 'name' => 'پەیمانگای ئێواران', 'emoji' => '🌆', 'sort_order' => 11, 'is_active' => true, 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('institution_types');
    }
};
