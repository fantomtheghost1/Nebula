extends Node

var client : Captain

#func _ready():
#	client = Captain(SteamManager.GetSteamUsername())

func GetShipFromID(id):
	var ships = get_tree().get_nodes_in_group("ships")
	for ship in ships:
		if ship.id == int(id):
			return ship
	return null

func ChangePlayerShip(new_ship_id):
	var ship_with_id = GetShipFromID(new_ship_id)	
	ship_with_id.SetOwner(SteamManager.GetSteamUsername())
	GlobalVariables.camera_gimbal.SetTarget(ship_with_id, false)
	GlobalVariables.camera_gimbal.InitScanner(ship_with_id.ship_type.scanner.scanner_range, ship_with_id.ship_type.scanner.zoom_max)
	ClearOtherDevShips(ship_with_id)
	
func ClearOtherDevShips(ship_instance):
	if GlobalVariables.dev_mode and GameManager.GetPlayerShips().size() > 1 and ship_instance.GetOwner() != "AI":
		var dev_ships = GameManager.GetPlayerShips()
		print("you can only have one dev ship")
		for ship in dev_ships:
			print(ship)
			print(ship_instance)
			if ship != ship_instance:
				ship.SetOwner("AI")
				
func IsObjectShip(object):
	var group_ships = get_tree().get_nodes_in_group("ships")
	var ships = []
	for ship in group_ships:
		if ship == object:
			return true
	return false
	
func GetPlayerShips():
	var group_ships = get_tree().get_nodes_in_group("ships")
	var ships = []
	for ship in group_ships:
		print(ship.GetOwner())
		if ship.GetOwner() != "AI":
			ships.append(ship)
	return ships
	
func GetAsteroidsCommand():
	var group_asteroids = get_tree().get_nodes_in_group("asteroids")
	var asteroids = ""
	for asteroid in group_asteroids:
		asteroids += str("id: ", asteroid.id, " ore_yield: ", asteroid.ore, " composition: ", HelperFunctions.GetEnumStringFromIndex(Item.ITEMS, asteroid.composition), "\n")
	return str(asteroids)
	
func GetShipsCommand():
	var group_ships = get_tree().get_nodes_in_group("ships")
	var ships = ""
	for ship in group_ships:
		ships += str("id: ", ship.id, " owner: ", ship.GetOwner(), "\n")
	return str(ships)
