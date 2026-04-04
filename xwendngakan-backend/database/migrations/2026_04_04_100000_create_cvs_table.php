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
        Schema::create('cvs', function (Blueprint $table) {
            $table->id();
            $table->string('name');                     // ناوی سیانی
            $table->string('phone');                    // ژمارەی تەلەفۆن
            $table->string('email')->nullable();        // ئیمەیڵ
            $table->string('city');                     // شار
            $table->integer('age')->nullable();         // تەمەن
            $table->enum('gender', ['male', 'female', 'other'])->nullable();  // ڕەگەز
            $table->string('graduation_year')->nullable();  // ساڵی دەرچوون
            $table->string('field');                    // بواری خوێندن / پیشە
            $table->string('education_level')->nullable();  // ئاستی خوێندن
            $table->text('experience')->nullable();     // ئەزموونی کار
            $table->text('skills')->nullable();         // بەهرەکان
            $table->text('notes')->nullable();          // تێبینی
            $table->string('photo')->nullable();        // وێنە
            $table->boolean('is_reviewed')->default(false);  // بینراوە لەلایەن ئەدمین
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cvs');
    }
};
