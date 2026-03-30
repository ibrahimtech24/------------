<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            // کەتەگۆرییەکانی سەرەکی
            ['key' => 'all', 'name' => '🌟 هەمووی', 'icon' => '🌟', 'sort_order' => 0],
            ['key' => 'gov', 'name' => '🎓 زانکۆ', 'icon' => '🎓', 'sort_order' => 1],
            ['key' => 'inst2', 'name' => '📗 پەیمانگەی ٢ ساڵی', 'icon' => '📗', 'sort_order' => 2],
            ['key' => 'inst5', 'name' => '📘 پەیمانگەی ٥ ساڵی', 'icon' => '📘', 'sort_order' => 3],
            ['key' => 'school', 'name' => '🏫 قوتابخانە', 'icon' => '🏫', 'sort_order' => 4],
            ['key' => 'kg', 'name' => '🧒 باخچەی منداڵان', 'icon' => '🧒', 'sort_order' => 5],
            ['key' => 'lang', 'name' => '📖 سەنتەری زمان', 'icon' => '📖', 'sort_order' => 6],
            ['key' => 'dc', 'name' => '👶 دایەنگە', 'icon' => '👶', 'sort_order' => 7],
            ['key' => 'edu', 'name' => '🏢 دامەزراوەی تر', 'icon' => '🏢', 'sort_order' => 8],
            
            // ژێرکەتەگۆرییەکانی زانکۆ
            ['key' => 'gov_all', 'name' => 'هەمووی', 'parent_key' => 'gov', 'sort_order' => 0],
            ['key' => 'gov_gov', 'name' => 'حکومی', 'parent_key' => 'gov', 'sort_order' => 1],
            ['key' => 'gov_priv', 'name' => 'تایبەت', 'parent_key' => 'gov', 'sort_order' => 2],
            
            // ژێرکەتەگۆرییەکانی قوتابخانە
            ['key' => 'sch_all', 'name' => 'هەمووی', 'parent_key' => 'school', 'sort_order' => 0],
            ['key' => 'sch_base', 'name' => 'بنەڕەتی', 'parent_key' => 'school', 'sort_order' => 1],
            ['key' => 'sch_prep', 'name' => 'ئامادەیی', 'parent_key' => 'school', 'sort_order' => 2],
        ];

        foreach ($categories as $category) {
            Category::updateOrCreate(
                ['key' => $category['key']],
                $category
            );
        }
    }
}
