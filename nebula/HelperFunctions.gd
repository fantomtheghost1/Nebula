extends Node

var system_names = ["test_system1", "test_system2", "test_system3", "test_system4", "test_system5"]
var rng = RandomNumberGenerator.new()

func GenerateName(object_type : String):
	if object_type == "system":
		return system_names[rng.randi_range(0, system_names.size() - 1)]
	return

func GetDistanceBetweenTwoPoints(point1, point2) -> float:
	var distance = sqrt(pow((point1.x - point2.x), 2) + pow((point1.z - point2.z), 2))
	return distance
	
func GetObjectInGroupByName(object_name, group_name) -> Node3D:
	var group_objects = get_tree().get_nodes_in_group(group_name)
	
	for group_object in group_objects:
		if group_object.name == object_name:
			return group_object
	return null
	
func CheckForObjectInGroup(object, group_name) -> bool:
	var group_objects = get_tree().get_nodes_in_group(group_name)
	
	for group_object in group_objects:
		if group_object == object:
			return true
	return false

func Debug(message: String) -> void:
	# Only print in debug mode
	if OS.is_debug_build():
		# ANSI escape code for yellow text
		var yellow = "\u001b[33m" 
		var reset = "\u001b[0m"
		# Print the debug message with yellow color
		print_debug(yellow + message + reset)
