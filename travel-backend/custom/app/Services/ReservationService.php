<?php

namespace App\Services;

use App\Models\{User, Reservation, Vol, Hotel};
use Illuminate\Support\Facades\DB;

class ReservationService
{
    public function createReservation(User $user, array $data): Reservation
    {
        return DB::transaction(function () use ($user, $data) {
            $vol = Vol::findOrFail($data['vol_id']);

            if ($vol->places_disponibles < $data['nombre_personnes']) {
                throw new \Exception('Places insuffisantes disponibles');
            }

            $prixTotal = $vol->prix * $data['nombre_personnes'];

            if (isset($data['hotel_id'])) {
                $hotel = Hotel::findOrFail($data['hotel_id']);
                $nuits = \Carbon\Carbon::parse($data['date_debut'])->diffInDays($data['date_fin']);
                $prixTotal += $hotel->prix_nuit * $nuits;
            }

            $reservation = Reservation::create([
                'user_id' => $user->id,
                'vol_id' => $data['vol_id'],
                'hotel_id' => $data['hotel_id'] ?? null,
                'date_debut' => $data['date_debut'],
                'date_fin' => $data['date_fin'],
                'nombre_personnes' => $data['nombre_personnes'],
                'prix_total' => $prixTotal,
                'statut' => 'en_attente',
                'reference' => Reservation::generateReference(),
            ]);

            $vol->decrementSeats($data['nombre_personnes']);

            return $reservation;
        });
    }

    public function updateReservation(Reservation $reservation, array $data): Reservation
    {
        DB::transaction(function () use ($reservation, $data) {
            if (isset($data['nombre_personnes']) && $data['nombre_personnes'] !== $reservation->nombre_personnes) {
                $diff = $data['nombre_personnes'] - $reservation->nombre_personnes;
                if ($diff > 0) {
                    $reservation->vol->decrementSeats($diff);
                } else {
                    $reservation->vol->increment('places_disponibles', abs($diff));
                }
            }

            $reservation->update($data);
        });

        return $reservation->fresh();
    }

    public function cancelReservation(Reservation $reservation): void
    {
        DB::transaction(function () use ($reservation) {
            $reservation->vol->increment('places_disponibles', $reservation->nombre_personnes);
            $reservation->update(['statut' => 'annulee']);
        });
    }
}
