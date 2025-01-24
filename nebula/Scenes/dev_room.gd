extends Node2D

@export var build_version : String = ""

var ship_max = preload("res://Resources/Ships/dummy_max.tres")

# initializes the game manager and creates a new ship
func _ready():
	print_debug("test")
	DisplayServer.window_set_title("Nebula " + build_version)
	
	print_debug("initializing globals")
	GlobalVariables.camera_gimbal = %CameraGimbal
	GlobalVariables.click_floor = %ClickFloor
	GlobalVariables.camera = get_node("CameraGimbal/Camera3D")
	GlobalVariables.main_scene = self
	GlobalVariables.ship_resource = ship_max
		
	print_debug("initializing game manager")
	var ship = GameManager.CreateShip(1, ship_max, "DEV")
	#var _ship2 = GameManager.CreateShip(1, ship_max)
#	print_debug(GameManager.DoesShipExist(1))
	
	GlobalVariables.camera_gimbal.SetTarget(ship, false)
