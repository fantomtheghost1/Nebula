extends Node

var ship_scene = preload("res://scenes/ship/ship.tscn")
var next_ship_id = 0

# creates a ship with the provided component types at the provided node location
func CreateShip(x : float, z : float, ship_type : String, is_ai : bool = false):
	var ship_resource = load("res://resources/ships/" + ship_type + ".tres")
	var new_ship = ship_scene.instantiate()
	GlobalVariables.main_scene.add_child(new_ship)
	new_ship.position = Vector3(x, 0, z)
	new_ship.Initialize(is_ai, ship_resource, next_ship_id)
	GameManager.ClearOtherDevShips(new_ship)
	next_ship_id += 1
	return new_ship
