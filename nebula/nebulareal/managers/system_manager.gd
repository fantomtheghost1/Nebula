extends Node

var rng = RandomNumberGenerator.new()

var systems = []

var system_sizes = [
	{
		"SIZE" : "small",
		"SUN_SCALE" : 50,
		"SYSTEM_SCALE_MULT" : 1,
		"ASTEROID_MIN" : 25,
		"ASTEROID_MAX" : 50
	},
	{
		"SIZE" : "medium",
		"SUN_SCALE" : 75,
		"SYSTEM_SCALE_MULT" : 1.5,
		"ASTEROID_MIN" : 50,
		"ASTEROID_MAX" : 150
	},
	{
		"SIZE" : "large",
		"SUN_SCALE" : 150,
		"SYSTEM_SCALE_MULT" : 2,
		"ASTEROID_MIN" : 100,
		"ASTEROID_MAX" : 250
	},
	{
		"SIZE" : "massive",
		"SUN_SCALE" : 250,
		"SYSTEM_SCALE_MULT" : 3,
		"ASTEROID_MIN" : 150,
		"ASTEROID_MAX" : 300
	}
]

func AddSystem(system : System) -> void:
	systems.append(system)
	
func GetRandomSystemSize():
	return system_sizes[rng.randi_range(0, 3)]

func GetSystemByName(system_name : String) -> System:
	for system in systems:
		if system_name == system.name:
			return system
			
	return null
	
func GetSystemByID(system_id : int) -> System:
	for system in systems:
		if system_id == system.id:
			return system
			
	return null

func GetAllSystemData():
	var data_dict = {}
	var index = 0
	for system in systems:
		if system:
			var data = {
				"id": system.id,
				"position": system.position,
				"name": system.system_name,
				"system_size": system.system_size,
				"sun_color": system.sun_color,
				"node_path": str(system.get_path())
			}
			data_dict[index] = data
			index += 1
	return data_dict
