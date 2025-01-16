extends Node2D

var GameManager = preload("res://Scenes/Managers/game_manager.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager = GameManager.new()
	print("initializing game manager")
	GameManager.CreateShip(1, "DUMMY_ZERO", "DUMMY_ZERO", "DUMMY_ZERO", self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
