<?php

namespace App\Filament\Widgets;

use App\Models\Institution;
use App\Models\User;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverview extends BaseWidget
{
    protected static ?int $sort = 1;

    protected function getStats(): array
    {
        $total = Institution::count();
        $approved = Institution::where('approved', true)->count();
        $pending = Institution::where('approved', false)->count();
        $users = User::count();

        $gov = Institution::where('approved', true)->where('type', 'gov')->count();
        $priv = Institution::where('approved', true)->where('type', 'priv')->count();
        $school = Institution::where('approved', true)->where('type', 'school')->count();
        $kg = Institution::where('approved', true)->where('type', 'kg')->count();
        $inst = Institution::where('approved', true)->whereIn('type', ['inst5', 'inst2'])->count();
        $dc = Institution::where('approved', true)->where('type', 'dc')->count();

        $cities = Institution::where('approved', true)
            ->distinct('city')
            ->count('city');

        return [
            Stat::make('کۆی خوێندنگاکان', $total)
                ->description('هەموو خوێندنگا تۆمارکراوەکان')
                ->descriptionIcon('heroicon-m-academic-cap')
                ->color('primary'),

            Stat::make('چاوەڕوانی پەسەندکردن', $pending)
                ->description($pending > 0 ? 'پێویستە پەسەند بکرێن' : 'هیچ داواکارییەک نییە')
                ->descriptionIcon($pending > 0 ? 'heroicon-m-exclamation-triangle' : 'heroicon-m-check-circle')
                ->color($pending > 0 ? 'danger' : 'success'),

            Stat::make('شارەکان', $cities)
                ->description('شاری جیاواز')
                ->descriptionIcon('heroicon-m-map-pin')
                ->color('info'),

            Stat::make('بەکارهێنەران', $users)
                ->description('کۆی بەکارهێنەران')
                ->descriptionIcon('heroicon-m-users')
                ->color('warning'),

            Stat::make('حکومی', $gov)
                ->description('زانکۆی حکومی')
                ->descriptionIcon('heroicon-m-building-library')
                ->color('primary'),

            Stat::make('ئەهلی', $priv)
                ->description('زانکۆی ئەهلی')
                ->descriptionIcon('heroicon-m-building-office')
                ->color('success'),

            Stat::make('قوتابخانە', $school)
                ->description('خوێندنگای سەرەتایی و ناوەندی')
                ->descriptionIcon('heroicon-m-book-open')
                ->color('warning'),

            Stat::make('پەیمانگا', $inst)
                ->description('پەیمانگاکان')
                ->descriptionIcon('heroicon-m-academic-cap')
                ->color('info'),
        ];
    }
}
