extends Node2D

func _ready() -> void:
	var particles: GPUParticles2D = $Particles
	particles.emitting = true

	var particles_ring: GPUParticles2D = $ParticlesRing
	particles_ring.emitting = true
