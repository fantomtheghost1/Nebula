extends Node

func LoadResourcesInFolder(folder_path : String):
	var resources = []
	for file_name in DirAccess.get_files_at(folder_path):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
		if (file_name.get_extension() == "tres"):
			resources.append(ResourceLoader.load(folder_path + "/" + file_name))
			
	return resources

func GetDistanceBetweenTwoPoints(point1, point2) -> float:
	var distance = sqrt(pow((point1.x - point2.x), 2) + pow((point1.z - point2.z), 2))
	return distance
	
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
