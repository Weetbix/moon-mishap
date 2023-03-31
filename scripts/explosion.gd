extends Node2D

func _ready():
	var particles : GPUParticles2D = $Particles
	particles.emitting = true

