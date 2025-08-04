extends Node

var ships = {}
var next_ship_id = 0

func AddShip(position : Vector3, rotation : Vector3, id : int, node_path : String):
	ships[next_ship_id] = {
		"position": position,
		"rotation": rotation,
		"id": id,
		"node_path": node_path
	}
	next_ship_id += 1
	
func GetShipByID(ship_id):
	for ship in ships:
		if ships[ship].id == ship_id:
			return ship
	
func GetShipPathByID(ship_id):
	for ship in ships:
		if ships[ship].id == ship_id:
			return ships[ship].node_path
			
func RemoveShip(ship_id):
	for ship in ships:
		if ships[ship].id == ship_id:
			var requested_ship = get_node_or_null(GetShipPathByID(ship_id))
			if requested_ship:
				requested_ship.queue_free()
			ships.erase(ship)

func GetAllShips():
	return ships
