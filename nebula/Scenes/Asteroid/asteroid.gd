extends Node3D

var object_type : String = "asteroid"
var composition : Resource
var ore : int

@export var id : int = 0
@export var resource : Resource

func _ready():
	if id != 0 and resource != null:
		Initialize(id, resource)

func Initialize(param_id, asteroid_type) -> void: 
	id = param_id
	composition = asteroid_type.composition
	ore = asteroid_type.ore
	
	if asteroid_type.asteroid_mesh != null:
		%AsteroidMesh.mesh = asteroid_type.asteroid_mesh
		
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
