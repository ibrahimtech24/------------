<?php

namespace App\Filament\Resources\QuickStatResource\Pages;

use App\Filament\Resources\QuickStatResource;
use Filament\Resources\Pages\CreateRecord;

class CreateQuickStat extends CreateRecord
{
    protected static string $resource = QuickStatResource::class;

    protected static bool $canCreateAnother = false;
}
