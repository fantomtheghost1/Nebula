extends Node

func GetShipFromID(id):
	var ships = get_tree().get_nodes_in_group("ships")
	for ship in ships:
		if ship.id == int(id):
			return ship
	return null
	
func GetShipFromCaptain(captain : Captain):
	var ships = get_tree().get_nodes_in_group("ships")
	for ship in ships:
		if ship.identity_comp.GetOwner() == captain.name:
			return ship
	return null
	
func GetClientShip():
	var group_ships = get_tree().get_nodes_in_group("ships")
	for ship in group_ships:
		if ship.identity_comp.GetOwner() == GlobalVariables.client_captain:
			return ship
	return null

func ChangePlayerShip(new_ship_id):
	var ship_with_id = GetShipFromID(new_ship_id)	
	ship_with_id.identity_comp.GetOwner().ChangeCurrentPilotedShip(null)
	ship_with_id.SetOwner.rpc(GlobalVariables.client_captain)
	GlobalVariables.camera_gimbal.SetTarget(ship_with_id, false)
	GlobalVariables.camera_gimbal.InitScanner(ship_with_id.ship_type.scanner.scanner_range, ship_with_id.ship_type.scanner.zoom_max)
	ClearOtherDevShips(ship_with_id)
	
func DamageShip(id : int, damage : int):
	var ship = GetShipFromID(id)
	if ship:
		ship.damage_handler.TakeDamage.rpc(damage, true)
		return "You have damaged ship " + str(id) + " by " + str(damage) + " damage!"
	
func ClearOtherDevShips(ship_instance):
	if GlobalVariables.dev_mode and GameManager.GetPlayerShips().size() > 1 and !ship_instance.identity_comp.GetOwner().is_ai:
		var dev_ships = GameManager.GetPlayerShips()
		for ship in dev_ships:
			if ship != ship_instance:
				pass
				#var new_ai_captain = GlobalVariables.captain_container.CreateCaptain(true)
				#ship.identity_component.SetOwner.rpc(new_ai_captain)
				
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
		if !ship.identity_comp.GetOwner().is_ai:
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
			ships += str("id: ", ship.id, " owner: ", ship.identity_comp.GetOwner().name)
		else:
			ships += str("id: ", ship.id, " owner: ", ship.identity_comp.GetOwner().name, "\n")
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
	
func GetRelaysCommand():
	var group_relays = get_tree().get_nodes_in_group("hyperlane_relays")
	var relays = ""
	var index = 0
	for relay in group_relays:
		if index == group_relays.size() - 1:
			relays += str("Position: ", relay.position, " System: ", relay.get_parent().get_parent().name)
		else:
			relays += str("Position: ", relay.position, " System: ", relay.get_parent().get_parent().name, "\n")
		index += 1
	return str(relays)
	
func GetStarbasesCommand():
	var group_starbases = get_tree().get_nodes_in_group("starbases")
	var starbases = ""
	var index = 0
	for starbase in group_starbases:
		if index == group_starbases.size() - 1:
			starbases += str("id: ", starbase.starbase_id, " system name: ", starbase.system_name, " position: ", starbase.position)
		else:
			starbases += str("id: ", starbase.starbase_id, " system name: ", starbase.system_name, " position: ", starbase.position, "\n")
		index += 1
	return str(starbases)
	
func WarpCommand(ship_id : int, system_id : int):
	var systems = get_tree().get_nodes_in_group("star_systems")
	var ships = get_tree().get_nodes_in_group("ships")
	
	var target_system = null
	var target_ship = null
	
	for system in systems:
		if system.id == system_id:
			target_system = system
		else:
			push_error("Error: Invalid system id...")
			return
			
	for ship in ships:
		if ship.id == ship_id:
			target_ship = ship
			
	target_ship.position = Vector3(target_system.position.x - 150, 0 , target_system.position.z - 150)
	target_ship.call_deferred("reparent", target_system.ship_container)

func Teleport(id : int, x : int, z : int) -> void:
	var ship = GetShipFromID(id)
	ship.position = Vector3(x, 0, z)
