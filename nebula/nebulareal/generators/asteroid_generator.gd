extends Node

var asteroid_scene = preload("res://scenes/asteroid/asteroid.tscn")
var asteroid_id = 0

func CreateAsteroid(x: float, z: float, size : String, composition : String, system_name : String):
	var new_asteroid = asteroid_scene.instantiate()
	#GlobalVariables.main_scene.add_child(new_asteroid)
	var system_asteroid_container = SystemManager.GetSystemByName(system_name).get_node("AsteroidContainer")
	system_asteroid_container.add_child(new_asteroid)
	new_asteroid.name = size + "_" + composition + "_asteroid_" + str(asteroid_id)
	new_asteroid.position = Vector3(x, 0, z)
	
	var resource = ResourceDb.GetAsteroidByProperties(size, composition)
	new_asteroid.Initialize(AsteroidManager.GetNextAsteroidID(), resource)
	AsteroidManager.AddAsteroid(new_asteroid)
	return new_asteroid
