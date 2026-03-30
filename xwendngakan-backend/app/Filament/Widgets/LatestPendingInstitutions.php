<?php

namespace App\Filament\Widgets;

use App\Models\Institution;
use Filament\Tables;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget as BaseWidget;

class LatestPendingInstitutions extends BaseWidget
{
    protected static ?string $heading = 'داواکارییە تازەکان (چاوەڕوانی پەسەندکردن)';

    protected static ?int $sort = 4;

    protected int | string | array $columnSpan = 'full';

    public function table(Table $table): Table
    {
        return $table
            ->query(
                Institution::query()
                    ->where('approved', false)
                    ->latest()
                    ->limit(10)
            )
            ->columns([
                Tables\Columns\TextColumn::make('nku')
                    ->label('ناوی کوردی')
                    ->searchable()
                    ->weight('bold'),
                Tables\Columns\TextColumn::make('nen')
                    ->label('ناوی ئینگلیزی')
                    ->toggleable(),
                Tables\Columns\TextColumn::make('type')
                    ->label('جۆر')
                    ->badge()
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'gov' => 'حکومی',
                        'priv' => 'ئەهلی',
                        'inst5' => 'پەیمانگا ٥',
                        'inst2' => 'پەیمانگا ٢',
                        'school' => 'قوتابخانە',
                        'kg' => 'باخچە',
                        'dc' => 'سەنتەر',
                        default => $state,
                    })
                    ->color(fn (string $state): string => match ($state) {
                        'gov' => 'primary',
                        'priv' => 'success',
                        'school' => 'warning',
                        'kg' => 'info',
                        default => 'gray',
                    }),
                Tables\Columns\TextColumn::make('city')
                    ->label('شار'),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('بەروار')
                    ->dateTime('Y/m/d H:i')
                    ->sortable(),
            ])
            ->actions([
                Tables\Actions\Action::make('approve')
                    ->label('پەسەندکردن')
                    ->icon('heroicon-o-check-circle')
                    ->color('success')
                    ->requiresConfirmation()
                    ->modalHeading('پەسەندکردنی خوێندنگا')
                    ->modalDescription('دڵنیایت لە پەسەندکردنی ئەم خوێندنگایە؟')
                    ->modalSubmitActionLabel('بەڵێ، پەسەندی بکە')
                    ->action(fn (Institution $record) => $record->update(['approved' => true])),
                Tables\Actions\Action::make('reject')
                    ->label('ڕەتکردنەوە')
                    ->icon('heroicon-o-x-circle')
                    ->color('danger')
                    ->requiresConfirmation()
                    ->modalHeading('سڕینەوەی داواکاری')
                    ->modalDescription('دڵنیایت لە سڕینەوەی ئەم داواکارییە؟')
                    ->modalSubmitActionLabel('بەڵێ، بیسڕەوە')
                    ->action(fn (Institution $record) => $record->delete()),
            ])
            ->emptyStateHeading('هیچ داواکارییەکی تازە نییە')
            ->emptyStateDescription('هەموو خوێندنگاکان پەسەندکراون')
            ->emptyStateIcon('heroicon-o-check-circle')
            ->paginated(false);
    }
}
