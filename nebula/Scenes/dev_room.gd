extends Node2D

# initializes the game manager and creates a new ship
func _ready():
	print("initializing globals")
	GlobalVariables.camera_gimbal = %CameraGimbal
	GlobalVariables.click_floor = %ClickFloor
	GlobalVariables.camera = get_node("CameraGimbal/Camera3D")
	GlobalVariables.main_scene = self
	
	print("initializing game manager")
	var ship = GameManager.CreateShip(1, "DEV", "RUNABOUT_CHASSIS", "DUMMY_ZERO_GENERATOR", "DUMMY_MIN_CARGO_BAY", "DUMMY_ZERO_SHIELD_GENERATOR", "DUMMY_ZERO_ENGINE")
	print(GameManager.DoesShipExist(1))
	
	GlobalVariables.camera_gimbal.SetTarget(ship, false)
