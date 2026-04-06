<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Drop old table and recreate with proper columns
        Schema::dropIfExists('teachers');

        Schema::create('teachers', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('phone', 20);
            $table->enum('type', ['university', 'school']);
            $table->string('city', 100);
            $table->integer('experience_years')->nullable();
            $table->integer('hourly_rate')->nullable();
            $table->text('about')->nullable();
            $table->string('photo')->nullable();
            $table->boolean('is_approved')->default(true);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('teachers');
    }
};
