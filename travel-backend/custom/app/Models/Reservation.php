<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Reservation extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'user_id',
        'vol_id',
        'hotel_id',
        'date_debut',
        'date_fin',
        'nombre_personnes',
        'prix_total',
        'statut',
        'reference',
    ];

    protected function casts(): array
    {
        return [
            'date_debut' => 'date',
            'date_fin' => 'date',
            'prix_total' => 'decimal:2',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function vol()
    {
        return $this->belongsTo(Vol::class);
    }

    public function hotel()
    {
        return $this->belongsTo(Hotel::class);
    }

    public function payments()
    {
        return $this->hasMany(Payment::class);
    }

    public static function generateReference(): string
    {
        return 'RES-' . strtoupper(uniqid());
    }
}
