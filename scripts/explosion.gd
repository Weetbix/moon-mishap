extends Node2D

func _ready():
	var particles : GPUParticles2D = $Particles
	particles.emitting = true

	var particles_ring : GPUParticles2D = $ParticlesRing
	particles_ring.emitting = true

