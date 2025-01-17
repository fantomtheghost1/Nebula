extends Node

var ship = preload("res://Scenes/Ship/ship.tscn")

# creates a ship with the provided component types at the provided node location
func CreateShip(instance_id : int, instance_chassis_type : String, instance_generator_type : String, instance_cargo_bay_type : String, instance_shield_generator_type : String, instance_location : Node):
	var new_ship = ship.instantiate()
	instance_location.add_child(new_ship)
	new_ship.Initialize(instance_chassis_type, instance_generator_type, instance_cargo_bay_type, instance_shield_generator_type, instance_id)
	return new_ship

func DoesShipExist(id):
	return get_parent().get_node("DevRoom/SHIPS").has_node(str(id))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
