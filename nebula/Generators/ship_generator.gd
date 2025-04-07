extends Node

var ship_scene = preload("res://scenes/ship/ship.tscn")
var next_ship_id = 0

# creates a ship with the provided component types at the provided node location
func CreateShip(x : float, z : float, ship_type : String, is_ai : bool = false, id : int = -1):
	var ship_resource = load("res://resources/ships/" + ship_type + ".tres")
	var new_ship = ship_scene.instantiate()
	GlobalVariables.main_scene.add_child(new_ship)
	new_ship.add_to_group("untargetables")
	new_ship.position = Vector3(x, 0, z)
	
	if id != -1:
		new_ship.Initialize(is_ai, ship_resource, id, SteamManager.client.name)
		#next_ship_id += 1
	else:
		new_ship.Initialize(is_ai, ship_resource, next_ship_id, SteamManager.client.name)
		next_ship_id += 1
		
	GameManager.ClearOtherDevShips(new_ship)
	return new_ship

func CreateShipWithResource(x : float, z : float, resource : Resource, is_ai : bool = false, id : int = -1):
	var new_ship = ship_scene.instantiate()
	GlobalVariables.main_scene.add_child(new_ship)
	new_ship.add_to_group("untargetables")
	new_ship.position = Vector3(x, 0, z)
	
	if id != -1:
		new_ship.Initialize(is_ai, resource, id, SteamManager.client.name)
		#next_ship_id += 1
	else:
		new_ship.Initialize(is_ai, resource, next_ship_id, SteamManager.client.name)
		next_ship_id += 1

	GameManager.ClearOtherDevShips(new_ship)
	return new_ship
