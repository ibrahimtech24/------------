<?php

namespace App\Filament\Widgets;

use App\Models\Institution;
use Filament\Widgets\ChartWidget;
use Illuminate\Support\Facades\DB;

class InstitutionCityChart extends ChartWidget
{
    protected static ?string $heading = 'خوێندنگاکان بەپێی شار';

    protected static ?int $sort = 3;

    protected static ?string $maxHeight = '280px';

    protected function getData(): array
    {
        $cities = Institution::where('approved', true)
            ->select('city', DB::raw('count(*) as total'))
            ->groupBy('city')
            ->orderByDesc('total')
            ->limit(10)
            ->get();

        return [
            'datasets' => [
                [
                    'label' => 'ژمارەی خوێندنگا',
                    'data' => $cities->pluck('total')->toArray(),
                    'backgroundColor' => '#3B82F6',
                    'borderRadius' => 6,
                ],
            ],
            'labels' => $cities->pluck('city')->toArray(),
        ];
    }

    protected function getType(): string
    {
        return 'bar';
    }

    protected function getOptions(): array
    {
        return [
            'plugins' => [
                'legend' => [
                    'display' => false,
                ],
            ],
            'scales' => [
                'y' => [
                    'beginAtZero' => true,
                    'ticks' => [
                        'stepSize' => 1,
                    ],
                ],
            ],
        ];
    }
}
