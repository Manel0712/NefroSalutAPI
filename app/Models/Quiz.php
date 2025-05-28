<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Juego;
use App\Models\Paciente;

class Quiz extends Model
{
    protected $table = "quizs";
    
    protected $fillable = [
        'pregunta',
        'option1',
        'option2',
        'option3',
        'correctOption',
        'categoria'
    ];

    public function pacientes()
    {
        return $this->belongsToMany(Paciente::class, "quiz_pacientes");
    }
}
