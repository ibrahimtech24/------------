<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Add multilingual columns to categories
        Schema::table('categories', function (Blueprint $table) {
            $table->string('name_en')->nullable()->after('name');
            $table->string('name_ar')->nullable()->after('name_en');
        });

        // Copy name to name_en as default, keep name as Kurdish
        DB::table('categories')->update(['name_en' => DB::raw('name')]);

        // Add multilingual columns to institution_types
        Schema::table('institution_types', function (Blueprint $table) {
            $table->string('name_en')->nullable()->after('name');
            $table->string('name_ar')->nullable()->after('name_en');
        });

        // Set English translations for institution types
        $translations = [
            'gov'      => ['en' => 'Public University',         'ar' => 'جامعة حكومية'],
            'priv'     => ['en' => 'Private University',        'ar' => 'جامعة أهلية'],
            'inst5'    => ['en' => '5-Year Institute',          'ar' => 'معهد ٥ سنوات'],
            'inst2'    => ['en' => '2-Year Institute',          'ar' => 'معهد سنتين'],
            'school'   => ['en' => 'School',                    'ar' => 'مدرسة'],
            'kg'       => ['en' => 'Kindergarten',              'ar' => 'روضة أطفال'],
            'dc'       => ['en' => 'Daycare',                   'ar' => 'حضانة'],
            'lang'     => ['en' => 'Language/Vocational Center', 'ar' => 'مركز لغات/مهني'],
            'edu'      => ['en' => 'Educational Organization',  'ar' => 'منظمة تربوية'],
            'eve_uni'  => ['en' => 'Evening University',        'ar' => 'جامعة مسائية'],
            'eve_inst' => ['en' => 'Evening Institute',         'ar' => 'معهد مسائي'],
        ];

        foreach ($translations as $key => $names) {
            DB::table('institution_types')
                ->where('key', $key)
                ->update([
                    'name_en' => $names['en'],
                    'name_ar' => $names['ar'],
                ]);
        }
    }

    public function down(): void
    {
        Schema::table('categories', function (Blueprint $table) {
            $table->dropColumn(['name_en', 'name_ar']);
        });

        Schema::table('institution_types', function (Blueprint $table) {
            $table->dropColumn(['name_en', 'name_ar']);
        });
    }
};
