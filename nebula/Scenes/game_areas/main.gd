extends Node3D

@export var build_version : String = ""

var paused = false

var essential_resource = preload("res://orignal.jpeg")
var ship_gen = preload("res://generators/ship_generator.gd").new()
var star_system : PackedScene = preload("res://scenes/star_system/star_system.tscn")

# initializes the game manager and creates a new ship
func _ready():
	
	DisplayServer.window_set_title("Nebula " + build_version)
	
	#print_debug("Initializing lobby")
	
	print("initializing globals")
	GlobalVariables.camera_gimbal = %CameraGimbal
	GlobalVariables.camera = get_node("CameraGimbal/Camera3D")
	GlobalVariables.main_scene = self
	
	print("initializing commands")
	CommandManager.Init(ship_gen)
	
	print("\ninitialization complete!\n")
	
	Console.execute("exec starbase")
	var ai_captain = CaptainManager.CreateAICaptain()
	var ai_faction = FactionManager.CreateFaction("AIFaction", Color(255, 255, 255), ai_captain)
	
	#var rng = RandomNumberGenerator.new()
	#for i in range(150):
	#	ship_gen.CreateShip(rng.randf_range(-100, 100), rng.randf_range(-100, 100), "dummy_max_mining")
	var new_system = star_system.instantiate()
	var new_system2 = star_system.instantiate()
	var new_system3 = star_system.instantiate()
	
	var connection : Array[Node3D] = [new_system2, new_system3]
	new_system.Initialize(1, connection)
	add_child(new_system)
	
	connection = [new_system, new_system3]
	new_system2.Initialize(2, connection)
	add_child(new_system2)
	new_system2.position = Vector3(-1000, 0 , -1000)
	
	connection = [new_system, new_system2]
	new_system3.Initialize(3, connection)
	add_child(new_system3)
	new_system3.position = Vector3(1000, 0 , 1000)
	
	#new_system.connections.append(new_system2)
	
	var ship = ship_gen.CreateShip(150, 150, "dummy_max_mining")
	ship.call_deferred("reparent", new_system.ship_container)
	#GlobalVariables.camera_gimbal.subject = new_system
