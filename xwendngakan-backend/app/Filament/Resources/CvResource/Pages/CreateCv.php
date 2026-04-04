<?php

namespace App\Filament\Resources\CvResource\Pages;

use App\Filament\Resources\CvResource;
use Filament\Resources\Pages\CreateRecord;

class CreateCv extends CreateRecord
{
    protected static string $resource = CvResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }
}
