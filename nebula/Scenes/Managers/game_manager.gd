extends Node

var ship = preload("res://Scenes/Ship/ship.tscn")

func CreateShip(instance_id : int, instance_generator_type : String, instance_cargo_bay_type : String, instance_shield_generator_type : String, instance_location : Node):
	var new_ship = ship.instantiate()
	print(get_tree())
	instance_location.add_child(new_ship)
	new_ship.generator_type = instance_generator_type
	new_ship.cargo_bay_type = instance_cargo_bay_type
	new_ship.shield_generator_type = instance_shield_generator_type
	new_ship.id = instance_id
	print("test")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
