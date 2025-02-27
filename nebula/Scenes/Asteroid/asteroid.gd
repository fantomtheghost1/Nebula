extends Node3D

var id : int
var composition : int
var ore : int

func Initialize(param_id, asteroid_type) -> void:
	id = param_id
	composition = asteroid_type.composition
	ore = asteroid_type.ore
	scale = scale * Vector3(asteroid_type.scale, asteroid_type.scale, asteroid_type.scale)

func TakeDamage(damage : int):
	var ore_yield = 0
	ore -= damage
	if ore <= 0:
		ore_yield = ore + damage
		queue_free()
	return {
		"ore_yield": damage,
		"composition": composition
	}
