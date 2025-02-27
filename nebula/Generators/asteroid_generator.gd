extends Node

var asteroid_scene = preload("res://scenes/asteroid/asteroid.tscn")

func CreateAsteroid(id : int, asteroid_type):
	var new_asteroid = asteroid_scene.instantiate()
	GlobalVariables.main_scene.add_child(new_asteroid)
	new_asteroid.Initialize(id, asteroid_type)
	return new_asteroid
