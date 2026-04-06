<?php

namespace App\Filament\Resources\TeacherRequestResource\Pages;

use App\Filament\Resources\TeacherRequestResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListTeacherRequests extends ListRecords
{
    protected static string $resource = TeacherRequestResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
