extends MultiplayerSpawner

var asteroid_scene = preload("res://scenes/asteroid/asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_function = SpawnAsteroid

func SpawnAsteroid():
	var asteroid = asteroid_scene.instantiate()
	
