extends Node2D

@export var build_version : String = ""

var paused = false

var asteroid_gen = preload("res://generators/asteroid_generator.gd").new()
var ship_max = preload("res://resources/ships/dummy_min.tres")
var large_gold = preload("res://resources/asteroid/large/large_ice.tres")

# initializes the game manager and creates a new ship
func _ready():
	print_debug("test")
	DisplayServer.window_set_title("Nebula " + build_version)
	
	print_debug("initializing globals")
	GlobalVariables.camera_gimbal = %CameraGimbal
	GlobalVariables.click_floor = %Floor
	GlobalVariables.camera = get_node("CameraGimbal/Camera3D")
	GlobalVariables.main_scene = self
	GlobalVariables.ship_resource = ship_max
		
	print_debug("initializing game manager")
	var ship = GameManager.CreateShip(1, ship_max, "DEV")
	
	var asteroid = asteroid_gen.CreateAsteroid(1, large_gold)
	GameManager.CreateShip(2, ship_max)
	#for i in range(160):
	#	GameManager.CreateShip(i, ship_max)
	#var _ship2 = GameManager.CreateShip(1, ship_max)
#	print_debug(GameManager.DoesShipExist(1))
	
	GlobalVariables.camera_gimbal.SetTarget(ship, false)
	
#func _input(event):
#	if event.is_action_pressed("pause"):
#		paused = !paused
#		get_tree().paused = paused
