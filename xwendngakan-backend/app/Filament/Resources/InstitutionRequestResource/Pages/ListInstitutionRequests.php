<?php

namespace App\Filament\Resources\InstitutionRequestResource\Pages;

use App\Filament\Resources\InstitutionRequestResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListInstitutionRequests extends ListRecords
{
    protected static string $resource = InstitutionRequestResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
