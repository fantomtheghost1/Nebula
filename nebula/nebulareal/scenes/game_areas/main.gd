extends Node3D

@export var build_version : String = ""
@export var update_header : String = ""

var essential_resource = preload("res://orignal.jpeg")

# initializes the game manager and creates a new ship
func _ready():
	%MainMenu.SetMenu(build_version, update_header)
	DisplayServer.window_set_title("Nebula " + build_version)
	
	GlobalVariables.camera_gimbal = %CameraGimbal
	GlobalVariables.camera = get_node("CameraGimbal/Camera3D")
	GlobalVariables.main_scene = self
	GlobalVariables.player_list = %PlayerList
	GlobalVariables.input_disabled = true
	GlobalVariables.faction_container = %FactionContainer
	GlobalVariables.captain_container = %CaptainContainer
	GlobalVariables.server_ping_interval = %ServerPingInterval
	GlobalVariables.faction_menu = %FactionMenu
	GlobalVariables.chat = %Chat
	GlobalVariables.main_menu = %MainMenu
	GlobalVariables.server_browser = %ServerBrowser
	GlobalVariables.settings = %Settings
	
	CommandManager.Init()
	
	print_rich("[color=light_blue]Initialization Complete!")
	
	if OS.has_feature("dedicated_server"):
		var arguments = {}
		for argument in OS.get_cmdline_args():
			# Parse valid command-line arguments into a dictionary
			if argument.find("=") > -1:
				var key_value = argument.split("=")
				arguments[key_value[0]] = key_value[1]
				
		if arguments.has("-n"):
			MultiplayerManager.server_name = arguments["-n"]
			print_rich("[color=yellow]Server Name Set to %s" % arguments["-n"])
		elif arguments.has("--name"):
			MultiplayerManager.server_name = arguments["--name"]
			print_rich("[color=yellow]Server Name Set to %s" % arguments["--name"])
			
		if arguments.has("-p"):
			MultiplayerManager.server_port = int(arguments["-p"])
			print_rich("[color=yellow]Server Port Set to %s" % arguments["-p"])
		elif arguments.has("--port"):
			MultiplayerManager.server_port = int(arguments["--port"])
			print_rich("[color=yellow]Server Port Set to %s" % arguments["--port"])
			
		if arguments.has("-pw"):
			MultiplayerManager.server_password = arguments["-pw"]
		elif arguments.has("--password"):
			MultiplayerManager.server_password = arguments["--password"]
			
		MultiplayerManager.Host()
		%ServerPingInterval.start()
		
func _on_server_ping_interval_timeout() -> void:
	GlobalVariables.server_browser_http.PingAPI(MultiplayerManager.SERVER_IP)
