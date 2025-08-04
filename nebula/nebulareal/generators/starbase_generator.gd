extends Node

var starbase_scene = preload("res://scenes/starbase/starbase.tscn")
var next_starbase_id = 0

# creates a starbase with the provided component types
func CreateStarbase(x : float, z : float, starbase_type : String, starbase_level : int, star_system_name : String = "Epsilon"):
	var resource = ResourceDb.GetStarbaseByProperty(starbase_type, starbase_level)
	var new_starbase = starbase_scene.instantiate()
	
	if star_system_name != "Epsilon":
		var system = HelperFunctions.GetObjectInGroupByName(star_system_name, "star_systems")
		if system != null:
			system.AddStarbase(new_starbase)
		else:
			GlobalVariables.main_scene.add_child(new_starbase)
	else:
		GlobalVariables.main_scene.add_child(new_starbase)
		
	new_starbase.position = Vector3(x, 0, z)
	new_starbase.Initialize(resource, next_starbase_id, star_system_name)
	
	StarbaseManager.AddStarbase(str(new_starbase.get_path()))
	next_starbase_id += 1
	print_rich("[color=yellow_green]Starbase created!")
	return new_starbase
