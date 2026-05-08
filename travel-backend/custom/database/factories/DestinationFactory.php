<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class DestinationFactory extends Factory
{
    public function definition(): array
    {
        $cities = ['Paris', 'Rome', 'Barcelone', 'Istanbul', 'Dubaï', 'Tokyo', 'New York', 'Marrakech'];
        $countries = ['France', 'Italie', 'Espagne', 'Turquie', 'Émirats', 'Japon', 'États-Unis', 'Maroc'];

        $index = fake()->numberBetween(0, count($cities) - 1);

        return [
            'name'        => $cities[$index],
            'country'     => $countries[$index],
            'description' => fake()->paragraph(),
            'image'       => null,
            'is_popular'  => fake()->boolean(40),
        ];
    }
}
