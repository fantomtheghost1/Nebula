extends Node

var asteroid_scene = preload("res://scenes/asteroid/asteroid.tscn")
var asteroid_id = 0

func CreateAsteroid(x: float, z: float, size : String, composition : String):
	var asteroid_resource = ResourceDb.GetAsteroidByProperties(size, composition)
	var new_asteroid = asteroid_scene.instantiate()
	GlobalVariables.main_scene.add_child(new_asteroid)
	new_asteroid.position = Vector3(x, 0, z)
	new_asteroid.name = size + "_" + composition + "_asteroid_" + str(asteroid_id)
	new_asteroid.Initialize(1, asteroid_resource)
	asteroid_id += 1
	return new_asteroid
