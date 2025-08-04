extends Node3D

func Explode():
	%ExplosionShockwave.emitting = true
	%ExplosionParticles.emitting = true

func _ready():
	Explode()
