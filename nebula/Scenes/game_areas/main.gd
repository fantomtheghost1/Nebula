extends Node3D

@export var build_version : String = ""

var paused = false

var essential_resource = preload("res://orignal.jpeg")
var system_type : Resource = preload("res://resources/systems/dummy_yellow.tres")
var star_system : PackedScene = preload("res://scenes/star_system/star_system.tscn")
var starbase_gen = preload("res://generators/starbase_generator.gd").new()
var asteroid_gen = preload("res://generators/asteroid_generator.gd").new()
var ship_gen = preload("res://generators/ship_generator.gd").new()

const COMMANDS = ["version", "create_asteroid", "asteroids", "ships", "reload", "create_ship", "change_player_ship", "create_faction", "faction_members", "create_starbase", "damage_ship", "systems", "warp", "teleport"]

# initializes the game manager and creates a new ship
func _ready():
	
	DisplayServer.window_set_title("Nebula " + build_version)
	
	#print_debug("Initializing lobby")
	
	print_debug("initializing globals")
	GlobalVariables.camera_gimbal = %CameraGimbal
	GlobalVariables.camera = get_node("CameraGimbal/Camera3D")
	GlobalVariables.main_scene = self
	
	print_debug("initializing commands")
	Console.create_command("version", self.NebulaBuildVersionCommand, "Returns the current Nebula build version.")
	Console.create_command("create_asteroid", asteroid_gen.CreateAsteroid, "Creates an asteroid at the given position with the given attributes. \nE.X: create_asteroid [x : float] [z : float] [size : String] [composition : String] \nSizes: small, medium, large, massive\nCompositions: magnesium_alloy, carbon_fiber, graphene, exotic_matter, titanium_alloy")
	Console.create_command("asteroids", GameManager.GetAsteroidsCommand, "Gets all the asteroids in the scene.")
	Console.create_command("ships", GameManager.GetShipsCommand, "Gets all the ships in the scene.")
	Console.create_command("create_ship", ship_gen.CreateShip, "Creates a ship in the current scene at the given location, owned by the given player, and with the given attributes based on the ship_type id. \nE.X: create_ship [x : float] [z : float] [ship_type : String] [is_ai : bool = false] \nShip Types: dummy_zero, dummy_min_mining, dummy_min_combat, dummy_max_mining, dummy_max_combat")
	Console.create_command("change_player_ship", GameManager.ChangePlayerShip, "Changes the player ship to the ship with the given id. \nE.X: change_player_ship [id : int]")
	Console.create_command("create_faction", FactionManager.CreateFaction, "Create a faction with a given name. \nE.X: create_faction [faction_name : String]")
	Console.create_command("create_starbase", starbase_gen.CreateStarbase, "Creates a starbase in the current scene at the given location, owned by the given player, and with the given attributes based on the starbase_type id. \nE.X: create_starbase [x : float] [z : float] [starbase_type : String] [starbase_id : String] \nStarbase Types: hq \nStarbase IDs: dummy_zero")
	Console.create_command("faction_members", FactionManager.GetFactionMembersCommand, "Gets all the faction members within a faction. \nE.X: get_faction_members [faction_name : String]")
	Console.create_command("damage_ship", GameManager.DamageShip, "Damages a ship determined by id by the given amount. \nE.X: damage_ship [id : int] [damage_amount : int]")
	Console.create_command("teleport", GameManager.Teleport, "Teleports the selected ship to the given coordinates. \nE.X: teleport [id : int] [x : int] [z : int]")
	Console.create_command("warp", GameManager.WarpCommand, "Warps to the given system. \nE.X: warp [ship_id : int] [system_id? : int] [system_name? : String]")
	Console.create_command("systems", GameManager.GetSystemsCommand, "Gets all the systems in the scene.")
	Console.create_command("reload", self.Reload, "Reloads the current scene.")
	
	#var rng = RandomNumberGenerator.new()
	#for i in range(150):
	#	ship_gen.CreateShip(rng.randf_range(-100, 100), rng.randf_range(-100, 100), "dummy_max_mining")
	var new_system = star_system.instantiate()
	var new_system2 = star_system.instantiate()
	var new_system3 = star_system.instantiate()
	
	var connection : Array[Node3D] = [new_system2, new_system3]
	new_system.Initialize(system_type, 1, connection)
	add_child(new_system)
	
	connection = [new_system3]
	new_system2.Initialize(system_type, 2, connection)
	add_child(new_system2)
	new_system2.position = Vector3(-1000, 0 , -1000)
	
	connection = [new_system]
	new_system3.Initialize(system_type, 3, connection)
	add_child(new_system3)
	new_system3.position = Vector3(1000, 0 , 1000)
	
	#new_system.connections.append(new_system2)
	
	var ship = ship_gen.CreateShip(150, 150, "dummy_max_mining")
	ship.call_deferred("reparent", new_system.ship_container)
	#GlobalVariables.camera_gimbal.subject = new_system
	
func NebulaBuildVersionCommand() -> String:
	return build_version

func Reload() -> void:
	get_tree().reload_current_scene()
	for command in COMMANDS:
		Console.remove_command(command)
