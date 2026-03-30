<?php

namespace App\Filament\Resources\InstitutionTypeResource\Pages;

use App\Filament\Resources\InstitutionTypeResource;
use Filament\Resources\Pages\ListRecords;
use Filament\Actions;

class ListInstitutionTypes extends ListRecords
{
    protected static string $resource = InstitutionTypeResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()
                ->label('جۆری نوێ'),
        ];
    }
}
