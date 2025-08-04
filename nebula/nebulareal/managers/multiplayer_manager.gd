extends Node

# Preload scene resources
var ship: PackedScene = preload("res://scenes/ship/ship.tscn")
var star_system: PackedScene = preload("res://scenes/star_system/star_system.tscn")
var main: PackedScene = preload("res://scenes/game_areas/main.tscn")
var starbase_gen: Node = preload("res://generators/starbase_generator.gd").new()

# Network configuration
const SERVER_IP: String = "172.233.131.183"
const PLAYER_LIMIT: int = 4

# Server configuration
var server_name: String = "New_Server"
var server_port: int = 8080
var server_password: String = ""
var player_count: int = 0

# Hosts a multiplayer server
func Host() -> void:
	print_rich("[color=light_blue]Hosting![/color]")
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(server_port, PLAYER_LIMIT, 2)
	
	if error != OK:
		push_error("Failed to create server: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(OnJoin)
	var success = multiplayer.peer_disconnected.connect(OnLeave)
	if success != OK:
		push_error("Failed to connect peer_disconnected signal!")
	
	GlobalVariables.server_browser_http.AddServer(server_name, str(server_port), server_password, PLAYER_LIMIT, SERVER_IP)
	GenerateSystems()

# Connects client to a server
func Join() -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	print_rich("[color=light_blue]Initial peer state: ", peer.get_connection_status(), "[/color]")
	print_rich("[color=light_blue]Joining server at server ip %s at the port %s" % [SERVER_IP, server_port], "[/color]")
	var error: Error = peer.create_client(SERVER_IP, server_port)
	
	if error != OK:
		push_error("Failed to create client: ", error)
		print_rich("[color=light_blue]Peer state after failure: ", peer.get_connection_status(), "[/color]")
		return
	
	multiplayer.multiplayer_peer = peer
	var joining: Control = GlobalVariables.main_scene.get_node("UI/MultiplayerUI/Joining")
	joining.show()
	joining.mouse_filter = joining.MOUSE_FILTER_STOP
	
	GlobalVariables.main_menu.hide()

# Disconnects a player by peer ID
func DisconnectPlayer(pid: int) -> void:
	if multiplayer.multiplayer_peer == null:
		push_error("Cannot kick peer %s: Multiplayer peer is null" % pid)
		return
	
	if multiplayer.get_peers().has(pid):
		print_rich("[color=yellow]Kicking peer %s[/color]" % pid)
		multiplayer.disconnect_peer(pid)
		multiplayer.peer_disconnected.emit(pid)

# Handles peer disconnection
func OnLeave(pid: int) -> void:
	print("test")
	GlobalVariables.captain_container.RemoveCaptain.rpc(pid)
	ShipManager.RemoveShip(pid)
	player_count -= 1
	GlobalVariables.server_browser_http.SetPlayerCount(SERVER_IP, player_count)
	
func OnDisconnect():
	get_tree().reload_current_scene()

# Handles new player joining
func OnJoin(pid: int) -> void:
	print_rich("[color=light_blue]Player %s has joined the game![/color]" % str(pid))
	
	player_count += 1
	GlobalVariables.server_browser_http.SetPlayerCount(SERVER_IP, player_count)
	
	ReplicationManager.AddSystemsToPeer(pid, SystemManager.GetAllSystemData())
	ReplicationManager.AddCaptainsToPeer(pid, GlobalVariables.captain_container.GetAllCaptainData())
	ReplicationManager.AddFactionsToPeer(pid, GlobalVariables.faction_container.GetAllFactionData())
	ReplicationManager.AddShipsToPeer(pid, ShipManager.GetAllShips())
	ReplicationManager.AddStarbasesToPeer(pid, StarbaseManager.GetAllStarbases())
	ReplicationManager.AddAsteroidsToPeer(pid, AsteroidManager.GetAllAsteroidData())
	ReplicationManager.AddRelaysToPeer(pid, RelayManager.GetAllRelayData())
	
	ReplicationManager.RequestUsernameFromClient(pid)

# Generates star systems for the game
func GenerateSystems() -> void:
	var new_system: Node = star_system.instantiate()
	var new_system2: Node = star_system.instantiate()
	
	GlobalVariables.main_scene.add_child(new_system, true)
	GlobalVariables.main_scene.add_child(new_system2, true)
	
	new_system.Initialize.rpc(1, Vector3(-1000, 0, -1000))
	var connection: Array[int] = [new_system.id]
	new_system2.Initialize.rpc(2, Vector3(0, 0, 0), connection)
	
	starbase_gen.CreateStarbase(150, 150, "hq", 1)

# Creates a starter ship for a player
func CreateStarterShip(pid: int) -> Node:
	var new_ship: Node = ship.instantiate()
	GlobalVariables.main_scene.add_child(new_ship)
	new_ship.SetName.rpc(str(pid))
	ShipManager.AddShip(new_ship.position, new_ship.rotation, pid, str(new_ship.get_path()))
	new_ship.Initialize.rpc("dummy_max_mining", pid)
	
	return new_ship

# Sets up UI for a connected client
@rpc("any_peer", "call_remote")
func SetupUI() -> void:
	if not multiplayer.server_disconnected.is_connected(OnDisconnect):
		multiplayer.server_disconnected.connect(OnDisconnect)
	var joining: Control = GlobalVariables.main_scene.get_node("UI/MultiplayerUI/Joining")
	joining.mouse_filter = joining.MOUSE_FILTER_IGNORE
	joining.hide()
	
	var server_browser: Control = GlobalVariables.main_scene.get_node("UI/MultiplayerUI/ServerBrowser")
	server_browser.mouse_filter = server_browser.MOUSE_FILTER_IGNORE
	server_browser.hide()
	
	var ping = GlobalVariables.main_scene.get_node("UI/Game/Ping")
	ping.show()
	
	GlobalVariables.faction_menu.show()
	GlobalVariables.faction_menu.PopulateFactionList()
	print_rich("[color=light_blue]Connected![/color]")

# Handles input for player list UI
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PlayerList") and !GlobalVariables.input_disabled:
		GlobalVariables.player_list.show()
	
	if event.is_action_released("PlayerList") and !GlobalVariables.input_disabled:
		GlobalVariables.player_list.hide()
