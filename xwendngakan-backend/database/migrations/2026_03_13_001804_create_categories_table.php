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
        Schema::create('categories', function (Blueprint $table) {
            $table->id();
            $table->string('key')->unique();           // کۆدی ناسێن: gov, priv, inst5, etc.
            $table->string('name');                    // ناو: 🎓 زانکۆ
            $table->string('icon')->nullable();        // ئایکۆن: 🎓
            $table->string('parent_key')->nullable();  // بۆ ژێرکەتەگۆری
            $table->integer('sort_order')->default(0); // ڕیزبەندی
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('categories');
    }
};
