extends Node

var asteroids : Array

var next_asteroid_id : int = 0

func AddAsteroid(asteroid : Asteroid):
	asteroids.append(asteroid)

func GetAsteroids():
	return asteroids
	
func GetAllAsteroidData():
	var data_dict = {}
	var index = 0
	for asteroid in asteroids:
		if asteroid:
			var data = {
				"position" : asteroid.position,
				"id": asteroid.id,
				"scale": asteroid.resource.scale,
				"composition_id": asteroid.composition.id,
				"node_path": str(asteroid.get_path())
			}
			data_dict[index] = data
			index += 1
		else:
			RemoveAsteroid(index)
			
	return data_dict
	
func RemoveAsteroid(asteroid_id : int):
	var index = 0
	for asteroid in asteroids:
		if asteroid.id == asteroid_id:
			asteroids.erase(index)
		index += 1
		
func GetAsteroidPaths():
	var paths = []
	for asteroid in asteroids:
		paths.append(asteroid.get_path())
		
	return paths
	
func GetNextAsteroidID():
	next_asteroid_id += 1
	return next_asteroid_id
	
func GetAsteroidFromID(id : int):
	for asteroid in asteroids:
		if asteroid.id == id:
			return asteroid

func SetAsteroids(asteroid_array : Array):
	asteroids = asteroid_array
