<?php

namespace App\Filament\Resources\InstitutionRequestResource\Pages;

use App\Filament\Resources\InstitutionRequestResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditInstitutionRequest extends EditRecord
{
    protected static string $resource = InstitutionRequestResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
