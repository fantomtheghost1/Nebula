extends Control

@export var player_list : Control
@export var chat : Control
@export var main_menu : Control
@export var faction_menu : Control
@export var server_browser : Control

var ship = preload("res://scenes/ship/ship.tscn")
var star_system : PackedScene = preload("res://scenes/star_system/star_system.tscn")

func _on_start_pressed() -> void:
	if %PlayerLimitSlider.value != 1.0 and MultiplayerManager.noray_connected:
		GlobalVariables.server_ping_interval.start()
		GlobalVariables.host_mode = true
		GlobalVariables.dev_console_tip.visible = true
		MultiplayerManager.Host()
		
		var server_name : String
		if %ServerNameLE.text == "":
			server_name = "%s's Server" % GlobalVariables.username
		else:
			server_name = %ServerNameLE.text
			
		server_name = server_name.replace(" ", "_")
		
	else:
		print_rich("[color=yellow]Creating single player game...")
	#GenerateSystems()
	chat.CreateChatMessage("Server", "Peer %s is hosting the game!" % str(multiplayer.get_unique_id()))
	GlobalVariables.captain_container.CreateCaptain.rpc(false, 1, GlobalVariables.username)
	CreateStarterShip(multiplayer.get_unique_id())
	player_list.PopulatePlayerList.rpc()
	main_menu.mouse_filter = main_menu.MOUSE_FILTER_IGNORE
	main_menu.hide()
	
	mouse_filter = MOUSE_FILTER_IGNORE
	hide()
	
	faction_menu.PopulateFactionList()
	faction_menu.show()
	faction_menu.mouse_filter = faction_menu.MOUSE_FILTER_STOP

	
func CreateStarterShip(pid):
	var new_ship = ship.instantiate()
	GlobalVariables.main_scene.add_child(new_ship)
	new_ship.SetName.rpc(str(pid))	
	ShipManager.AddShip(new_ship.position, new_ship.rotation, pid, str(new_ship.get_path()))
	new_ship.Initialize.rpc("dummy_max_mining", pid)
	
	return new_ship
	
	#new_system.connections.append(new_system2)
	#ship.call_deferred("reparent", new_system.ship_container)
	#GlobalVariables.camera_gimbal.subject = new_system
	#obbyManager.CreateLobby()

func _on_back_pressed() -> void:
	server_browser.EnableAPICalls()
	hide()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	server_browser.show()
	server_browser.mouse_filter = server_browser.MOUSE_FILTER_STOP

func _on_player_limit_slider_value_changed(value: float) -> void:
	%PlayerLimitCount.text = str(int(value)) + " Player"
	if value > 1:
		%PlayerLimitCount.text = str(int(value)) + " Players"
