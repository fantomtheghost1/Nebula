extends Node

var ship_scene = preload("res://scenes/ship/ship.tscn")
var next_ship_id = 0

# creates a ship with the provided component types at the provided node location
func CreateShip(x : float = 150, z : float = 150, ship_name : String = "dummy_max_mining", is_ai : bool = false, id : int = -1):
	var ship_resource = ResourceDb.GetShipByName(ship_name)
	var new_ship = ship_scene.instantiate()
	new_ship.name = str(multiplayer.get_unique_id())
	GlobalVariables.main_scene.add_child(new_ship, true)
	new_ship.position = Vector3(x, 0, z)
	
	if id != -1:
		new_ship.Initialize(is_ai, ship_resource, id, GlobalVariables.client_captain.name)
		next_ship_id += 1
	else:
		new_ship.Initialize(is_ai, ship_resource, next_ship_id, GlobalVariables.client_captain.name)
		next_ship_id += 1
		
	GameManager.ClearOtherDevShips(new_ship)
	print_rich("[color=yellow_green]Ship Created!")
	return new_ship

func CreateShipWithResource(x : float, z : float, resource : Resource, is_ai : bool = false, id : int = -1):
	var new_ship = ship_scene.instantiate()
	GlobalVariables.main_scene.add_child(new_ship, true)
	new_ship.position = Vector3(x, 0, z)
	
	if id != -1:
		new_ship.Initialize(is_ai, resource, id, GlobalVariables.client_captain.name)
		next_ship_id += 1
	else:
		new_ship.Initialize(is_ai, resource, next_ship_id, GlobalVariables.client_captain.name)
		next_ship_id += 1

	GameManager.ClearOtherDevShips(new_ship)
	print_rich("[color=yellow_green]Ship Created!")
	return new_ship
