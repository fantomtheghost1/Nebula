extends Node

var ship_scene = preload("res://scenes/ship/ship.tscn")

# creates a ship with the provided component types at the provided node location
func CreateShip(id : int, ship_type : Resource, ship_owner : String = "AI"):
	var new_ship = ship_scene.instantiate()
	GlobalVariables.main_scene.add_child(new_ship)
	new_ship.Initialize(ship_owner, ship_type, id)
	return new_ship

func DoesShipExist(id):
	var ships = get_tree().get_nodes_in_group("ships")
	for ship in ships:
		if ship.id == id:
			return ship
	return null
