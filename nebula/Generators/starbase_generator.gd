extends Node

var starbase_scene = preload("res://scenes/starbase/starbase.tscn")
var next_starbase_id = 0

# creates a starbase with the provided component types
func CreateStarbase(x : float, z : float, starbase_type : String, starbase_id : String):
	var resource = load("res://resources/starbases/" + starbase_type + "/" + starbase_id + "_" + starbase_type + ".tres")
	var new_starbase = starbase_scene.instantiate()
	GlobalVariables.main_scene.add_child(new_starbase)
	new_starbase.position = Vector3(x, 0, z)
	new_starbase.Initialize(resource, next_starbase_id)
	next_starbase_id += 1
	return new_starbase
