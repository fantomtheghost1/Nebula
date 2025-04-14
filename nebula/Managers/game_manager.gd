extends Node

func GetShipFromID(id):
	var ships = get_tree().get_nodes_in_group("ships")
	for ship in ships:
		if ship.id == int(id):
			return ship
	return null

func ChangePlayerShip(new_ship_id):
	var ship_with_id = GetShipFromID(new_ship_id)	
	ship_with_id.SetOwner(SteamManager.client.name)
	GlobalVariables.camera_gimbal.SetTarget(ship_with_id, false)
	GlobalVariables.camera_gimbal.InitScanner(ship_with_id.ship_type.scanner.scanner_range, ship_with_id.ship_type.scanner.zoom_max)
	ClearOtherDevShips(ship_with_id)
	
func DamageShip(id : int, damage : int):
	var ship = GetShipFromID(id)
	if ship != null:
		ship.TakeDamage(damage, true)
		return "You have damaged ship " + str(id) + " by " + str(damage) + " damage!"
	
func ClearOtherDevShips(ship_instance):
	if GlobalVariables.dev_mode and GameManager.GetPlayerShips().size() > 1 and ship_instance.GetOwner() != "AI":
		var dev_ships = GameManager.GetPlayerShips()
		for ship in dev_ships:
			if ship != ship_instance:
				ship.SetOwner("AI")
				
func IsObjectShip(object):
	var group_ships = get_tree().get_nodes_in_group("ships")
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
		asteroids += str("id: ", asteroid.id, " ore_yield: ", asteroid.ore, " composition: ", asteroid.composition.name, "\n")
	return str(asteroids)
	
func GetShipsCommand():
	var group_ships = get_tree().get_nodes_in_group("ships")
	var ships = ""
	var index = 0
	for ship in group_ships:
		if index == group_ships.size() - 1:
			ships += str("id: ", ship.id, " owner: ", ship.GetOwner())
		else:
			ships += str("id: ", ship.id, " owner: ", ship.GetOwner(), "\n")
	return str(ships)
	
func GetSystemsCommand():
	var group_systems = get_tree().get_nodes_in_group("star_systems")
	var systems = ""
	var index = 0
	for system in group_systems:
		if index == group_systems.size() - 1:
			systems += str("id: ", system.id, " name: ", system.name)
		else:
			systems += str("id: ", system.id, " name: ", system.name, "\n")
		index += 1
	return str(systems)
	
func WarpCommand(ship_id : int, system_id : int = -1, system_name : String = ""):
	var systems = get_tree().get_nodes_in_group("star_systems")
	var ships = get_tree().get_nodes_in_group("ships")
	
	var target_system = null
	var target_ship = null
	
	for system in systems:
		if system_id != -1:
			if system.id == system_id:
				target_system = system
		elif system_name != "":
			if system.system_name == system_name:
				target_system = system
		else:
			print("please enter a valid parameter")
			return
			
	for ship in ships:
		if ship.id == ship_id:
			target_ship = ship
			
	target_ship.position = Vector3(target_system.position.x - 150, 0 , target_system.position.z - 150)
	target_ship.call_deferred("reparent", target_system.ship_container)

func Teleport(id : int, x : int, z : int) -> void:
	var ship = GetShipFromID(id)
	ship.position = Vector3(x, 0, z)
