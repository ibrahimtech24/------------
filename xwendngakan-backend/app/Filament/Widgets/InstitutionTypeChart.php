<?php

namespace App\Filament\Widgets;

use App\Models\Institution;
use Filament\Widgets\ChartWidget;

class InstitutionTypeChart extends ChartWidget
{
    protected static ?string $heading = 'خوێندنگاکان بەپێی جۆر';

    protected static ?int $sort = 2;

    protected static ?string $maxHeight = '280px';

    protected function getData(): array
    {
        $types = [
            'gov' => 'حکومی',
            'priv' => 'ئەهلی',
            'inst5' => 'پەیمانگا ٥',
            'inst2' => 'پەیمانگا ٢',
            'school' => 'قوتابخانە',
            'kg' => 'باخچە',
            'dc' => 'سەنتەر',
        ];

        $counts = [];
        $labels = [];
        foreach ($types as $key => $label) {
            $count = Institution::where('approved', true)->where('type', $key)->count();
            if ($count > 0) {
                $counts[] = $count;
                $labels[] = $label;
            }
        }

        return [
            'datasets' => [
                [
                    'label' => 'ژمارە',
                    'data' => $counts,
                    'backgroundColor' => [
                        '#3B82F6', // blue - gov
                        '#10B981', // emerald - priv
                        '#8B5CF6', // purple - inst5
                        '#6366F1', // indigo - inst2
                        '#F59E0B', // amber - school
                        '#06B6D4', // cyan - kg
                        '#EC4899', // pink - dc
                    ],
                    'borderWidth' => 0,
                ],
            ],
            'labels' => $labels,
        ];
    }

    protected function getType(): string
    {
        return 'doughnut';
    }
    
    protected function getOptions(): array
    {
        return [
            'plugins' => [
                'legend' => [
                    'position' => 'bottom',
                    'labels' => [
                        'padding' => 16,
                        'usePointStyle' => true,
                    ],
                ],
            ],
            'cutout' => '65%',
        ];
    }
}
