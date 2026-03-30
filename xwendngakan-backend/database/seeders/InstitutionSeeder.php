<?php

namespace Database\Seeders;

use App\Models\Institution;
use Illuminate\Database\Seeder;

class InstitutionSeeder extends Seeder
{
    public function run(): void
    {
        $institutions = [
            ['nku' => "\u{0632}\u{0627}\u{0646}\u{06a9}\u{06c6}\u{06cc} \u{0633}\u{06d5}\u{0644}\u{0627}\u{062d}\u{06d5}\u{062f}\u{062f}\u{06cc}\u{0646}", 'nen' => 'University of Salahaddin', 'type' => 'gov', 'web' => 'https://su.edu.krd/', 'city' => "\u{0647}\u{06d5}\u{0648}\u{0644}\u{06ce}\u{0631}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
            ['nku' => "\u{0632}\u{0627}\u{0646}\u{06a9}\u{06c6}\u{06cc} \u{0633}\u{0644}\u{06ce}\u{0645}\u{0627}\u{0646}\u{06cc}", 'nen' => 'University of Sulaimani', 'type' => 'gov', 'web' => 'https://univsul.edu.iq/', 'city' => "\u{0633}\u{0644}\u{06ce}\u{0645}\u{0627}\u{0646}\u{06cc}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
            ['nku' => "\u{0632}\u{0627}\u{0646}\u{06a9}\u{06c6}\u{06cc} \u{062f}\u{0647}\u{06c6}\u{06a9}", 'nen' => 'University of Duhok', 'type' => 'gov', 'web' => 'https://uod.ac/', 'city' => "\u{062f}\u{0647}\u{06c6}\u{06a9}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
            ['nku' => "\u{0632}\u{0627}\u{0646}\u{06a9}\u{06c6}\u{06cc} \u{06a9}\u{06c6}\u{06cc}\u{06d5}", 'nen' => 'University of Koya', 'type' => 'gov', 'web' => 'https://koyauniversity.org/', 'city' => "\u{06a9}\u{06c6}\u{06cc}\u{06d5}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
            ['nku' => "\u{0632}\u{0627}\u{0646}\u{06a9}\u{06c6}\u{06cc} \u{062c}\u{06cc}\u{0647}\u{0627}\u{0646}", 'nen' => 'Cihan University', 'type' => 'priv', 'web' => 'https://cihanuniversity.edu.iq/', 'city' => "\u{0647}\u{06d5}\u{0648}\u{0644}\u{06ce}\u{0631}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
            ['nku' => "\u{0632}\u{0627}\u{0646}\u{06a9}\u{06c6}\u{06cc} \u{0644}\u{0648}\u{0628}\u{0646}\u{0627}\u{0646}-\u{0641}\u{06d5}\u{0631}\u{06d5}\u{0646}\u{0633}\u{06cc}", 'nen' => 'Lebanese French University', 'type' => 'priv', 'web' => 'https://lfu.edu.krd/', 'city' => "\u{0647}\u{06d5}\u{0648}\u{0644}\u{06ce}\u{0631}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
            ['nku' => "\u{067e}\u{06d5}\u{06cc}\u{0645}\u{0627}\u{0646}\u{06af}\u{0627}\u{06cc} \u{0695}\u{0627}\u{0628}\u{06d5}\u{0631}", 'nen' => 'Raber Institute', 'type' => 'inst2', 'city' => "\u{0647}\u{06d5}\u{0648}\u{0644}\u{06ce}\u{0631}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
            ['nku' => "\u{0642}\u{0648}\u{062a}\u{0627}\u{0628}\u{062e}\u{0627}\u{0646}\u{06d5}\u{06cc} \u{0695}\u{06c6}\u{0634}\u{0646}\u{0628}\u{06cc}\u{0631}\u{06cc}", 'nen' => 'Roshnbiry School', 'type' => 'school', 'city' => "\u{0633}\u{0644}\u{06ce}\u{0645}\u{0627}\u{0646}\u{06cc}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
            ['nku' => "\u{0628}\u{0627}\u{062e}\u{0686}\u{06d5}\u{06cc} \u{06af}\u{0648}\u{06b5}\u{06d5}\u{06a9}\u{06d5}\u{0645}", 'nen' => 'Gulakam Kindergarten', 'type' => 'kg', 'city' => "\u{0647}\u{06d5}\u{0648}\u{0644}\u{06ce}\u{0631}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
            ['nku' => "\u{0633}\u{06d5}\u{0646}\u{062a}\u{06d5}\u{0631}\u{06cc} \u{0648}\u{0634}\u{06d5}", 'nen' => 'Wsha Center', 'type' => 'dc', 'city' => "\u{0633}\u{0644}\u{06ce}\u{0645}\u{0627}\u{0646}\u{06cc}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => false],
            ['nku' => "\u{0632}\u{0627}\u{0646}\u{06a9}\u{06c6}\u{06cc} \u{0695}\u{0627}\u{067e}\u{06d5}\u{0631}\u{06cc}\u{0646}", 'nen' => 'Raparin University', 'type' => 'gov', 'web' => 'https://uor.edu.krd/', 'city' => "\u{0695}\u{0627}\u{0646}\u{06cc}\u{06d5}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
            ['nku' => "\u{0632}\u{0627}\u{0646}\u{06a9}\u{06c6}\u{06cc} \u{06af}\u{06d5}\u{0631}\u{0645}\u{06cc}\u{0627}\u{0646}", 'nen' => 'University of Garmian', 'type' => 'gov', 'web' => 'https://garmian.edu.krd/', 'city' => "\u{06a9}\u{06d5}\u{0644}\u{0627}\u{0631}", 'country' => "\u{0639}\u{06ce}\u{0631}\u{0627}\u{0642}", 'approved' => true],
        ];

        foreach ($institutions as $data) {
            Institution::updateOrCreate(
                ['nen' => $data['nen']],
                $data
            );
        }
    }
}
