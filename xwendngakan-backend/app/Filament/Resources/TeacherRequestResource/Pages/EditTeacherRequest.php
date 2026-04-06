<?php

namespace App\Filament\Resources\TeacherRequestResource\Pages;

use App\Filament\Resources\TeacherRequestResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditTeacherRequest extends EditRecord
{
    protected static string $resource = TeacherRequestResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
