<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Categoria;
use App\Models\Paciente;

class Video extends Model
{
    protected $fillable = [
        "titulo",
        "link",
        "categoria_id"
    ];

    public function categorias()
    {
        return $this->belongsTo(Categoria::class, "categoria_id");
    }

    public function pacientes()
    {
        return $this->belongsToMany(Paciente::class, "paciente_videos")->withPivot('num_visualizaciones', 'estado_visualizacion');
    }
}
