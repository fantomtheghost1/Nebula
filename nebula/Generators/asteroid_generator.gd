extends Node

var asteroid_scene = preload("res://scenes/asteroid/asteroid.tscn")

func CreateAsteroid(x: float, z: float, size : String, composition : String):
	var asteroid_resource = load("res://resources/asteroid/" + size + "/" + size + "_" + composition + ".tres")
	var new_asteroid = asteroid_scene.instantiate()
	GlobalVariables.main_scene.add_child(new_asteroid)
	new_asteroid.position = Vector3(x, 0, z)
	new_asteroid.Initialize(1, asteroid_resource)
	return new_asteroid
