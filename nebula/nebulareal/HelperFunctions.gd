extends Node

var laser = preload("res://scenes/projectile/laser_beam.tscn")
var laser_particles = preload("res://scenes/vfx/laser_particle.tscn")
var system_names = ["test_system1", "test_system2", "test_system3", "test_system4", "test_system5"]
var rng = RandomNumberGenerator.new()

func GenerateName(object_type : String):
	if object_type == "system":
		var system_name = system_names[rng.randi_range(0, system_names.size() - 1)]
		system_names.erase(system_name)
		return system_name
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
	
func GetAsteroidSizeFromScale(scale : int):
	match scale:
		1:
			return "small"
		2:
			return "medium"
		3:
			return "large"
		4:
			return "massive"
	
func CheckForObjectInGroup(object, group_name) -> bool:
	var group_objects = get_tree().get_nodes_in_group(group_name)
	
	for group_object in group_objects:
		if group_object == object:
			return true
	return false
	
@rpc("any_peer", "call_remote", "reliable")
func CreateLaser(ship_id, target_pos, beam_color):
	if multiplayer.get_peers().has(ship_id):
		var ship = get_node(ShipManager.GetShipPathByID(ship_id))
		var laser_spawn = get_node(ShipManager.GetShipPathByID(ship_id) + "/LaserSpawn")
		
		var laser_instance = laser.instantiate()
		laser_spawn.add_child(laser_instance, true)
		laser_instance.SetHeight.rpc(HelperFunctions.GetDistanceBetweenTwoPoints(ship.global_position, target_pos))
		laser_instance.look_at(target_pos)
		laser_instance.SetColor.rpc(beam_color)

		var laser_particles_instance = laser_particles.instantiate()
		laser_instance.add_child(laser_particles_instance, true)
		laser_particles_instance.global_position = target_pos
		laser_particles_instance.look_at(ship.global_position)

		laser_instance.set_multiplayer_authority(1)
