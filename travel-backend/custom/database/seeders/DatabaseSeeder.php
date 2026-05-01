<?php

namespace Database\Seeders;

use App\Models\{User, Destination, Vol, Hotel, Guide};
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::create([
            'name' => 'Admin',
            'email' => 'admin@travelapp.com',
            'password' => Hash::make('password'),
            'role' => 'admin',
        ]);

        User::factory(10)->create();

        $destinations = Destination::factory(8)->create();

        $destinations->each(function ($destination) {
            Vol::factory(5)->create(['destination_id' => $destination->id]);
            Hotel::factory(3)->create(['destination_id' => $destination->id]);
            Guide::factory(2)->create(['destination_id' => $destination->id]);
        });
    }
}
