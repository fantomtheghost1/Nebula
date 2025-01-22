extends Node

var ship = preload("res://Scenes/Ship/ship.tscn")

# creates a ship with the provided component types at the provided node location
func CreateShip(instance_id : int, instance_owner : String, instance_chassis_type : String, instance_generator_type : String, instance_cargo_bay_type : String, instance_shield_generator_type : String, instance_engine_type : String, instance_location : Node):
	var new_ship = ship.instantiate()
	instance_location.add_child(new_ship)
	new_ship.Initialize(instance_owner, instance_chassis_type, instance_generator_type, instance_cargo_bay_type, instance_shield_generator_type, instance_engine_type, instance_id)
	return new_ship

func DoesShipExist(id):
	var ships = get_tree().get_nodes_in_group("ships")
	for ship in ships:
		if ship.id == id:
			return ship
	return null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
