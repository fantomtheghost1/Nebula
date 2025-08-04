extends Node

# Sends system data to a specific peer
func AddSystemsToPeer(pid: int, system_data_dict: Dictionary) -> void:
	for system_data in system_data_dict:
		rpc_id(pid, "AddSystem", system_data_dict[system_data])

# RPC to add a system to the game world
@rpc("authority", "call_remote", "reliable")
func AddSystem(system_data: Dictionary) -> void:
	var system_id: int = system_data["id"]
	var system_position: Vector3 = system_data["position"]
	var system_name: String = system_data["name"]
	var system_size: Dictionary = system_data["system_size"]
	var sun_color: Color = system_data["sun_color"]
	var system: Node = get_node(system_data["node_path"])
	
	system.InitializeWithPresetValues(system_id, system_name, system_size, sun_color)
	system.position = system_position

# Sends asteroid data to a specific peer
func AddAsteroidsToPeer(pid: int, asteroid_data_dict: Dictionary) -> void:
	for asteroid_data in asteroid_data_dict:
		if asteroid_data:
			rpc_id(pid, "AddAsteroid", asteroid_data_dict[asteroid_data])

# RPC to add an asteroid to the game world
@rpc("authority", "call_remote", "reliable")
func AddAsteroid(asteroid_data: Dictionary) -> void:
	var id: int = asteroid_data["id"]
	var size: String = HelperFunctions.GetAsteroidSizeFromScale(asteroid_data["scale"])
	var composition_string: String = ResourceDb.GetItemByID(asteroid_data["composition_id"]).name
	composition_string = "_".join(composition_string.split(" ")).to_lower()
	
	var resource: Resource = ResourceDb.GetAsteroidByProperties(size, composition_string)
	var asteroid: Node = get_node(asteroid_data["node_path"])
	AsteroidManager.AddAsteroid(asteroid)
	
	asteroid.position = asteroid_data["position"]
	asteroid.Initialize(id, resource)

# Sends ship data to a specific peer
func AddShipsToPeer(pid: int, ship_data_dict: Dictionary) -> void:
	for ship_data in ship_data_dict:
		var ship: Node = get_node(ship_data_dict[ship_data]["node_path"])
		ship_data_dict[ship_data]["position"] = ship.position
		ship_data_dict[ship_data]["rotation"] = ship.rotation
		rpc_id(pid, "AddShip", ship_data_dict[ship_data])

# RPC to add a ship to the game world
@rpc("authority", "call_remote", "reliable")
func AddShip(ship_data: Dictionary) -> void:
	var position: Vector3 = ship_data["position"]
	var rotation: Vector3 = ship_data["rotation"]
	var id: int = ship_data["id"]
	var ship: Node = get_node(ship_data["node_path"])
	
	ship.position = position
	ship.rotation = rotation
	ship.id = id
	ship.name = str(id)

# Sends starbase data to a specific peer
func AddStarbasesToPeer(pid: int, starbase_data_dict: Dictionary) -> void:
	for starbase_data in starbase_data_dict:
		rpc_id(pid, "AddStarbase", starbase_data_dict[starbase_data])

# RPC to add a starbase to the game world
@rpc("authority", "call_remote", "reliable")
func AddStarbase(starbase_data: Dictionary) -> void:
	var id: int = starbase_data["id"]
	var system_name: String = starbase_data["system_name"]
	var level: int = starbase_data["level"]
	var starbase_type: String = starbase_data["starbase_type"]
	var starbase: Node = get_node(starbase_data["node_path"])
	
	var resource: Resource = ResourceDb.GetStarbaseByProperty(starbase_type, level)
	starbase.Initialize(resource, id, system_name)
	starbase.position = starbase_data["position"]
	starbase.rotation = starbase_data["rotation"]

# Sends faction data to a specific peer
func AddFactionsToPeer(pid: int, faction_data_dict: Dictionary) -> void:
	for faction_data in faction_data_dict:
		rpc_id(pid, "AddFaction", faction_data_dict[faction_data])

# RPC to add a faction to the game
@rpc("authority", "call_remote", "reliable")
func AddFaction(faction_data: Dictionary) -> void:
	var faction: Node = get_node(faction_data["node_path"])
	
	faction.faction_name = faction_data["faction_name"]
	faction.faction_leader = faction_data["faction_leader"]
	faction.faction_color = faction_data["faction_color"]
	faction.faction_members = faction_data["faction_members"]
	faction.diplomacy = faction_data["diplomacy"]

# Sends captain data to a specific peer
func AddCaptainsToPeer(pid: int, captain_data_dict: Dictionary) -> void:
	for captain_data in captain_data_dict:
		rpc_id(pid, "AddCaptain", captain_data_dict[captain_data])

# RPC to add or update a captain in the game
@rpc("authority", "call_remote", "reliable")
func AddCaptain(captain_data: Dictionary) -> void:
	var captain: Node = get_node_or_null(captain_data["node_path"])
	
	if captain:
		captain.pid = captain_data["pid"]
		captain.captain_name = captain_data["captain_name"]
		captain.faction_name = captain_data["faction_name"]
		captain.credits = captain_data["credits"]
		captain.is_ai = captain_data["is_ai"]
		captain.ai_id = captain_data["ai_id"]
	else:
		GlobalVariables.captain_container.CreateCaptain(false, captain_data["pid"], captain_data["captain_name"])
		captain = get_node_or_null(captain_data["node_path"])
		captain.faction_name = captain_data["faction_name"]
		captain.credits = captain_data["credits"]
		captain.is_ai = captain_data["is_ai"]
		captain.ai_id = captain_data["ai_id"]

# Sends relay data to a specific peer
func AddRelaysToPeer(pid: int, relay_data_dict: Dictionary) -> void:
	for relay_data in relay_data_dict:
		rpc_id(pid, "AddRelay", relay_data_dict[relay_data])

# RPC to add a relay to the game world
@rpc("authority", "call_remote", "reliable")
func AddRelay(relay_data: Dictionary) -> void:
	var relay: Node = get_node(relay_data["node_path"])
	
	relay.warp_pos = relay_data["warp_pos"]
	relay.position = relay_data["position"]
	relay.ship_container_path = relay_data["ship_container_path"]

# Requests username from a client
@rpc("authority", "call_local", "reliable")
func RequestUsernameFromClient(pid: int) -> void:
	print_debug("RPC to caller %s" % multiplayer.multiplayer_peer.get_unique_id())
	rpc_id(pid, "RequestCaptainFromServer", pid)

# Requests captain data from the server
@rpc("authority", "call_local", "reliable")
func RequestCaptainFromServer(pid: int) -> void:
	rpc_id(1, "CreateCaptainForClient", pid, GlobalVariables.username)

# Creates a captain for a client
@rpc("any_peer", "call_local", "reliable")
func CreateCaptainForClient(pid: int, username: String) -> void:
	print_debug("RPC to caller %s" % multiplayer.multiplayer_peer.get_unique_id())
	GlobalVariables.captain_container.CreateCaptain.rpc(false, pid, username)
	GlobalVariables.player_list.PopulatePlayerList.rpc()
	MultiplayerManager.SetupUI.rpc_id(pid)
	MultiplayerManager.CreateStarterShip(pid)
	GlobalVariables.chat.CreateChatMessage("Server", "Player " + str(pid) + " has joined the game!")
