extends Node3D

@export var generator_type = ""
@export var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	%GeneratorComponent.generator_type = generator_type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_generator_component_generator_destroyed(ship_id):
	if ship_id == id:
		print("generator destroyed on ship " + str(id))
