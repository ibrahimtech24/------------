<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('institutions', function (Blueprint $table) {
            $table->id();
            // Names
            $table->string('nku')->nullable();        // Kurdish name
            $table->string('nen')->nullable();         // English name
            $table->string('nar')->nullable();         // Arabic name
            // Classification
            $table->string('type')->default('edu');     // gov, priv, inst5, inst2, school, kg, dc
            $table->string('country')->nullable();
            $table->string('city')->nullable();
            // Contact
            $table->string('web')->nullable();
            $table->string('phone')->nullable();
            $table->string('email')->nullable();
            $table->string('addr')->nullable();
            $table->text('desc')->nullable();
            // University fields
            $table->text('colleges')->nullable();
            $table->text('depts')->nullable();
            // School fields
            $table->string('fee')->nullable();
            $table->string('meal')->nullable();
            $table->string('uniform')->nullable();
            $table->string('books')->nullable();
            $table->string('level')->nullable();
            // KG/DC fields
            $table->string('kg_fee')->nullable();
            $table->string('kg_meal')->nullable();
            $table->string('kg_uniform')->nullable();
            $table->string('kg_age')->nullable();
            $table->string('kg_hours')->nullable();
            // Social media
            $table->string('fb')->nullable();
            $table->string('ig')->nullable();
            $table->string('tg')->nullable();
            $table->string('wa')->nullable();
            $table->string('tk')->nullable();
            $table->string('yt')->nullable();
            // Media
            $table->string('logo')->nullable();
            $table->string('img')->nullable();
            // Status
            $table->boolean('approved')->default(false);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('institutions');
    }
};
