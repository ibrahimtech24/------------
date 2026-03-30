<?php

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class SettingsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'key' => 'category.all',
                'value' => '🌟 هەمووی',
                'label' => 'ناوی کەتەگۆری: هەمووی',
                'description' => 'ناوی کەتەگۆریی "هەمووی" کە لە ئەپەکەدا پیشان دەدرێت',
            ],
            [
                'key' => 'category.gov',
                'value' => '🎓 زانکۆ',
                'label' => 'ناوی کەتەگۆری: زانکۆ',
                'description' => 'ناوی کەتەگۆریی "زانکۆ" (حکومی و تایبەت)',
            ],
            [
                'key' => 'category.inst2',
                'value' => '📗 پەیمانگەی ٢ ساڵی',
                'label' => 'ناوی کەتەگۆری: پەیمانگەی ٢ ساڵی',
                'description' => 'ناوی پەیمانگاکانی دوو ساڵی',
            ],
            [
                'key' => 'category.inst5',
                'value' => '📘 پەیمانگەی ٥ ساڵی',
                'label' => 'ناوی کەتەگۆری: پەیمانگەی ٥ ساڵی',
                'description' => 'ناوی پەیمانگاکانی پێنج ساڵی',
            ],
            [
                'key' => 'category.school',
                'value' => '🏫 قوتابخانە',
                'label' => 'ناوی کەتەگۆری: قوتابخانە',
                'description' => 'ناوی کەتەگۆریی قوتابخانەکان',
            ],
            [
                'key' => 'category.kg',
                'value' => '🧒 باخچەی منداڵان',
                'label' => 'ناوی کەتەگۆری: باخچەی منداڵان',
                'description' => 'ناوی کەتەگۆریی باخچەی منداڵان',
            ],
            [
                'key' => 'category.lang',
                'value' => '📖 سەنتەری زمان',
                'label' => 'ناوی کەتەگۆری: سەنتەری زمان',
                'description' => 'ناوی کەتەگۆریی سەنتەری زمان',
            ],
            [
                'key' => 'category.dc',
                'value' => '👶 دایەنگە',
                'label' => 'ناوی کەتەگۆری: دایەنگە',
                'description' => 'ناوی کەتەگۆریی دایەنگە',
            ],
            [
                'key' => 'category.edu',
                'value' => '🏢 دامەزراوەی تر',
                'label' => 'ناوی کەتەگۆری: دامەزراوەی تر',
                'description' => 'ناوی کەتەگۆریی دامەزراوە پەروەردەییەکانی تر',
            ],
            // Subcategories for University
            [
                'key' => 'category.gov_all',
                'value' => 'هەمووی',
                'label' => 'ژێرکەتەگۆری زانکۆ: هەمووی',
                'description' => 'هەموو زانکۆکان',
            ],
            [
                'key' => 'category.gov_gov',
                'value' => 'حکومی',
                'label' => 'ژێرکەتەگۆری زانکۆ: حکومی',
                'description' => 'زانکۆی حکومی',
            ],
            [
                'key' => 'category.gov_priv',
                'value' => 'تایبەت',
                'label' => 'ژێرکەتەگۆری زانکۆ: تایبەت',
                'description' => 'زانکۆی تایبەت',
            ],
            // Subcategories for School
            [
                'key' => 'category.sch_all',
                'value' => 'هەمووی',
                'label' => 'ژێرکەتەگۆری قوتابخانە: هەمووی',
                'description' => 'هەموو قوتابخانەکان',
            ],
            [
                'key' => 'category.sch_base',
                'value' => 'بنەڕەتی',
                'label' => 'ژێرکەتەگۆری قوتابخانە: بنەڕەتی',
                'description' => 'قوتابخانەی بنەڕەتی',
            ],
            [
                'key' => 'category.sch_prep',
                'value' => 'ئامادەیی',
                'label' => 'ژێرکەتەگۆری قوتابخانە: ئامادەیی',
                'description' => 'قوتابخانەی ئامادەیی',
            ],
        ];

        foreach ($categories as $category) {
            Setting::updateOrCreate(
                ['key' => $category['key']],
                [
                    'value' => $category['value'],
                    'type' => 'text',
                    'group' => 'categories',
                    'label' => $category['label'],
                    'description' => $category['description'] ?? null,
                ]
            );
        }

        // General app settings
        $generalSettings = [
            [
                'key' => 'app.name',
                'value' => 'خوێندنگاکانم',
                'label' => 'ناوی ئەپ',
                'description' => 'ناوی سەرەکیی ئەپڵیکەیشن',
                'group' => 'app',
            ],
            [
                'key' => 'app.version',
                'value' => '1.0.0',
                'label' => 'وەشانی ئەپ',
                'description' => 'ژمارەی وەشانی ئەپڵیکەیشن',
                'group' => 'app',
            ],
        ];

        foreach ($generalSettings as $setting) {
            Setting::updateOrCreate(
                ['key' => $setting['key']],
                [
                    'value' => $setting['value'],
                    'type' => 'text',
                    'group' => $setting['group'],
                    'label' => $setting['label'],
                    'description' => $setting['description'] ?? null,
                ]
            );
        }
    }
}
