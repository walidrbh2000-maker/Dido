<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreReservationRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'vol_id'           => 'required|exists:vols,id',
            'hotel_id'         => 'nullable|exists:hotels,id',
            'date_debut'       => 'required|date|after_or_equal:today',
            'date_fin'         => 'required|date|after:date_debut',
            'nombre_personnes' => 'required|integer|min:1|max:10',
        ];
    }

    public function messages(): array
    {
        return [
            'vol_id.required'              => 'Le vol est obligatoire',
            'vol_id.exists'                => "Le vol sélectionné n'existe pas",
            'hotel_id.exists'              => "L'hôtel sélectionné n'existe pas",
            'date_debut.required'          => 'La date de début est obligatoire',
            'date_debut.after_or_equal'    => "La date de début doit être aujourd'hui ou ultérieure",
            'date_fin.required'            => 'La date de fin est obligatoire',
            'date_fin.after'               => 'La date de fin doit être après la date de début',
            'nombre_personnes.required'    => 'Le nombre de personnes est obligatoire',
            'nombre_personnes.min'         => 'Au moins 1 personne est requise',
            'nombre_personnes.max'         => 'Maximum 10 personnes par réservation',
        ];
    }
}
