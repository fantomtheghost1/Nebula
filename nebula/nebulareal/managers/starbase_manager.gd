extends Node

var starbases = {}
var next_starbase_id = 0

func AddStarbase(node_path : String):
	var starbase = get_node(node_path)
	starbases[next_starbase_id] = {
		"id": starbase.id,
		"position": starbase.position,
		"rotation": starbase.rotation,
		"system_name": starbase.system_name,
		"level": starbase.level,
		"starbase_type": starbase.starbase_type,
		"node_path": node_path
	}
	next_starbase_id += 1

func GetAllStarbases():
	return starbases
