<?php

namespace App\Filament\Resources\QuickStatResource\Pages;

use App\Filament\Resources\QuickStatResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditQuickStat extends EditRecord
{
    protected static string $resource = QuickStatResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
