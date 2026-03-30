<?php

namespace App\Filament\Resources\InstitutionTypeResource\Pages;

use App\Filament\Resources\InstitutionTypeResource;
use Filament\Resources\Pages\CreateRecord;

class CreateInstitutionType extends CreateRecord
{
    protected static string $resource = InstitutionTypeResource::class;

    protected static bool $canCreateAnother = false;
}
