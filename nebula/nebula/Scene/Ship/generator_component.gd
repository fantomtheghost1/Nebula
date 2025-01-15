extends Node3D

signal GeneratorDestroyed(ship_node)

@export var generator_type : String = ""

var max_power : int = 0
var hp : int = 0
var destroyed : bool = false
var generator_set : bool = false

const GENERATORS = {"DUMMY_MAX_GENERATOR":{"MAX_POWER":1000, "HP": 100},
					"DUMMY_MIN_GENERATOR":{"MAX_POWER":100, "HP": 100},
					"DUMMY_ZERO":{"MAX_POWER":0, "HP":0}}

func SetGenerator(generator_type : String):
	generator_set = true
	max_power = GENERATORS[generator_type]["MAX_POWER"]
	hp = GENERATORS[generator_type]["HP"]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0 and !destroyed and generator_set:
		DestroyComponent()
	if !generator_set:
		if generator_type != null:
			SetGenerator(generator_type)

func DestroyComponent():
	destroyed = true
	GeneratorDestroyed.emit(get_parent().id)
