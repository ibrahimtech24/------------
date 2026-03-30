<?php

namespace Database\Seeders;

use App\Models\QuickStat;
use Illuminate\Database\Seeder;

class QuickStatSeeder extends Seeder
{
    public function run(): void
    {
        $stats = [
            [
                'key' => 'universities',
                'label' => 'زانکۆ',
                'icon' => 'building_35',
                'color' => '#8B5CF6',
                'count_type' => 'type',
                'count_value' => 'gov,priv',
                'sort_order' => 1,
                'is_active' => true,
            ],
            [
                'key' => 'colleges',
                'label' => 'کۆلێژ',
                'icon' => 'bank5',
                'color' => '#3B82F6',
                'count_type' => 'type',
                'count_value' => 'inst5',
                'sort_order' => 2,
                'is_active' => true,
            ],
            [
                'key' => 'institutes',
                'label' => 'پەیمانگا',
                'icon' => 'building5',
                'color' => '#10B981',
                'count_type' => 'type',
                'count_value' => 'inst2',
                'sort_order' => 3,
                'is_active' => true,
            ],
            [
                'key' => 'schools',
                'label' => 'قوتابخانە',
                'icon' => 'teacher5',
                'color' => '#F59E0B',
                'count_type' => 'type',
                'count_value' => 'school',
                'sort_order' => 4,
                'is_active' => true,
            ],
        ];

        foreach ($stats as $stat) {
            QuickStat::updateOrCreate(
                ['key' => $stat['key']],
                $stat
            );
        }
    }
}
