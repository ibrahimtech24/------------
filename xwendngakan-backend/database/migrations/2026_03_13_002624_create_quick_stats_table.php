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
        Schema::create('quick_stats', function (Blueprint $table) {
            $table->id();
            $table->string('key')->unique();           // کۆد: universities, colleges, etc.
            $table->string('label');                   // ناو: زانکۆ، کۆلێژ
            $table->string('icon')->nullable();        // ئایکۆن: building_35
            $table->string('color');                   // ڕەنگ: #8B5CF6
            $table->string('count_type');              // جۆری ژمارە: type یان custom
            $table->string('count_value')->nullable(); // نرخ: gov,priv یان ژمارەی custom
            $table->integer('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('quick_stats');
    }
};
