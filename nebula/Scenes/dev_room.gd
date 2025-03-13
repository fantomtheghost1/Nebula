extends Node2D

@export var build_version : String = ""

var paused = false

var asteroid_gen = preload("res://generators/asteroid_generator.gd").new()
var ship_gen = preload("res://generators/ship_generator.gd").new()

const COMMANDS = ["version", "create_asteroid", "get_asteroids", "get_ships", "reload", "create_ship", "change_player_ship", "create_faction"]

# initializes the game manager and creates a new ship
func _ready():
	print_debug("test")
	DisplayServer.window_set_title("Nebula " + build_version)
	
	print_debug("initializing globals")
	GlobalVariables.camera_gimbal = %CameraGimbal
	GlobalVariables.click_floor = %Floor
	GlobalVariables.camera = get_node("CameraGimbal/Camera3D")
	GlobalVariables.main_scene = self
		
	print_debug("initializing game manager")
	var ship = ship_gen.CreateShip(0, 0, "dummy_min", "DEV")
	
	#var asteroid = asteroid_gen.CreateAsteroid(1, Vector3(10, 0, 10), large_gold)
	ship_gen.CreateShip(0, 0, "dummy_max")
	#for i in range(160):
	#	GameManager.CreateShip(i, ship_max)
	#var _ship2 = GameManager.CreateShip(1, ship_max)
#	print_debug(GameManager.DoesShipExist(1))
	
	Console.create_command("version", self.NebulaBuildVersionCommand, "Returns the current Nebula build version.")
	Console.create_command("create_asteroid", asteroid_gen.CreateAsteroid, "Creates an asteroid at the given position with the given attributes. \nE.X: create_asteroid [x : float] [z : float] [size : String] [composition : String] \nSizes: small, medium, large, massive\nCompositions: magnesium_alloy, carbon_fiber, graphene, exotic_matter, titanium_alloy")
	Console.create_command("get_asteroids", GameManager.GetAsteroidsCommand, "Gets all the asteroids in the scene.")
	Console.create_command("get_ships", GameManager.GetShipsCommand, "Gets all the ships in the scene.")
	Console.create_command("create_ship", ship_gen.CreateShip, "Creates a ship in the current scene at the given location, owned by the given player, and with the given attributes based on the ship_type id. \nE.X: create_ship [x : float] [z : float] [ship_type : String] [owner : String = AI] \nShip Types: dummy_zero, dummy_min, dummy_max")
	Console.create_command("change_player_ship", GameManager.ChangePlayerShip, "Changes the player ship to the ship with the given id. \nE.X: change_player_ship [id : int]")
	Console.create_command("create_faction", FactionManager.CreateFaction, "Create a faction with a given name. \nE.X: create_faction [faction_name : String]")
	Console.create_command("reload", self.Reload, "Reloads the current scene.")
	
func NebulaBuildVersionCommand() -> String:
	return build_version

func Reload() -> void:
	get_tree().reload_current_scene()
	for command in COMMANDS:
		Console.remove_command(command)
