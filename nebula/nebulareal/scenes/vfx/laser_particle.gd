extends Node3D

func _ready() -> void:
	%LaserParticles.emitting = true

func _on_laser_particles_finished() -> void:
	queue_free()
