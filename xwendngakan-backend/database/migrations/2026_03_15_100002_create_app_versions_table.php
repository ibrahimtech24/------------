<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_versions', function (Blueprint $table) {
            $table->id();
            $table->string('platform'); // 'android', 'ios'
            $table->string('version'); // e.g., '1.0.0'
            $table->integer('build_number'); // e.g., 1
            $table->boolean('force_update')->default(false);
            $table->string('store_url')->nullable();
            $table->text('release_notes')->nullable();
            $table->text('release_notes_en')->nullable();
            $table->text('release_notes_ar')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_versions');
    }
};
