<?php

namespace App\Filament\Resources;

use App\Filament\Resources\QuickStatResource\Pages;
use App\Models\QuickStat;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class QuickStatResource extends Resource
{
    protected static ?string $model = QuickStat::class;

    protected static bool $shouldRegisterNavigation = false;

    protected static ?string $navigationLabel = 'ئامارە خێراکان';

    protected static ?string $modelLabel = 'ئامارە خێرا';

    protected static ?string $pluralModelLabel = 'ئامارە خێراکان';

    protected static ?string $navigationGroup = 'بەڕێوەبردن';

    protected static ?int $navigationSort = 3;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make('زانیاری ئامارە')
                    ->description('ناو و ڕەنگ و ئایکۆن دابنێ')
                    ->icon('heroicon-o-chart-bar')
                    ->schema([
                        Forms\Components\TextInput::make('key')
                            ->label('کۆد (Key)')
                            ->required()
                            ->unique(ignoreRecord: true)
                            ->maxLength(50)
                            ->placeholder('universities, colleges...')
                            ->helperText('کۆدی ناسین - ئینگلیزی'),
                        
                        Forms\Components\TextInput::make('label')
                            ->label('ناو')
                            ->required()
                            ->maxLength(255)
                            ->placeholder('زانکۆ')
                            ->helperText('ناوی کوردی کە پیشان دەدرێت'),
                        
                        Forms\Components\TextInput::make('icon')
                            ->label('ئایکۆن')
                            ->maxLength(50)
                            ->placeholder('building_35')
                            ->helperText('ناوی ئایکۆن لە Iconsax'),
                        
                        Forms\Components\ColorPicker::make('color')
                            ->label('ڕەنگ')
                            ->required()
                            ->default('#8B5CF6'),
                        
                        Forms\Components\Select::make('count_type')
                            ->label('جۆری ژمارە')
                            ->required()
                            ->options([
                                'type' => '📊 ژمارەی دامەزراوەکان بەپێی جۆر',
                                'custom' => '✏️ ژمارەی دەستی',
                            ])
                            ->default('type')
                            ->reactive()
                            ->native(false),
                        
                        Forms\Components\TextInput::make('count_value')
                            ->label(fn ($get) => $get('count_type') === 'custom' ? 'ژمارە' : 'جۆرەکان')
                            ->required()
                            ->placeholder(fn ($get) => $get('count_type') === 'custom' ? '25' : 'gov,priv')
                            ->helperText(fn ($get) => $get('count_type') === 'custom' 
                                ? 'ژمارەیەک بنووسە' 
                                : 'جۆرەکان جیا بکەرەوە بە (,) - مثلاً: gov,priv'),
                        
                        Forms\Components\TextInput::make('sort_order')
                            ->label('ڕیزبەندی')
                            ->numeric()
                            ->default(0),
                        
                        Forms\Components\Toggle::make('is_active')
                            ->label('چالاک')
                            ->default(true),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('sort_order')
                    ->label('#')
                    ->sortable()
                    ->width(50),
                
                Tables\Columns\ColorColumn::make('color')
                    ->label('ڕەنگ')
                    ->width(50),
                
                Tables\Columns\TextColumn::make('label')
                    ->label('ناو')
                    ->searchable()
                    ->weight('bold'),
                
                Tables\Columns\TextColumn::make('key')
                    ->label('کۆد')
                    ->badge()
                    ->color('gray'),
                
                Tables\Columns\TextColumn::make('count_type')
                    ->label('جۆری ژمارە')
                    ->badge()
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'type' => '📊 بەپێی جۆر',
                        'custom' => '✏️ دەستی',
                        default => $state,
                    }),
                
                Tables\Columns\TextColumn::make('count_value')
                    ->label('نرخ'),
                
                Tables\Columns\IconColumn::make('is_active')
                    ->label('چالاک')
                    ->boolean(),
            ])
            ->filters([
                Tables\Filters\TernaryFilter::make('is_active')
                    ->label('چالاک'),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([])
            ->defaultSort('sort_order')
            ->reorderable('sort_order');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListQuickStats::route('/'),
            'create' => Pages\CreateQuickStat::route('/create'),
            'edit' => Pages\EditQuickStat::route('/{record}/edit'),
        ];
    }
}
