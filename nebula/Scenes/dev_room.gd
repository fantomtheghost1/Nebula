extends Node2D

# initializes the game manager and creates a new ship
func _ready():
	print("initializing game manager")
	var ship = GameManager.CreateShip(1, "RUNABOUT_CHASSIS", "DUMMY_ZERO_GENERATOR", "DUMMY_MIN_CARGO_BAY", "DUMMY_ZERO_SHIELD_GENERATOR", %SHIPS)
