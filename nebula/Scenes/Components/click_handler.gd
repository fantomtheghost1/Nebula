extends Node3D

# set to a very high arbitrary number
const RAY_LENGTH = 10000000000

# holds important node references
var identity_component : Node3D
var ship_node : Node3D
var ship_model : Node3D
@export var targeting_component : Node3D
@export var ship_movement : Node3D
@export var visible_waypoints : bool

func _input(event):

	# if the ship is owned by the client
	if identity_component.object_owner == SteamManager.client:
		
		# this will fire when the client presses the interact action without holding alt or shift
		if event.is_action_pressed("Interact") and !Input.is_physical_key_pressed(KEY_ALT) and !Input.is_physical_key_pressed(KEY_SHIFT) and !GlobalVariables.input_disabled:
			
			# determines what the mouse clicked on
			var result = DetermineClickSubject()
			# if the mouse clicked on something, check if its another ship or just the invisible floor
			if result != null:
				
				var object = result["collider"].get_parent()
				print(object)
				
				# if the mouse clicked the invisible floor, then create a waypoint 
				# and reset the current queue in ship movement so that the waypoint 
				# the ship is moving to is changed
				if HelperFunctions.CheckForObjectInGroup(object, "hyperlane_relays"):
					print("you have clicked a relay!")
					object.Warp(ship_node)
				# this conditional will fire if the object clicked is a ship. will be implemented later when the multiplayer is started
				elif HelperFunctions.CheckForObjectInGroup(object, "starbases"):
					object.get_node("ServiceContainer/DockComponent").AddQueuedDockingShip(ship_node)
					%WaypointQueueHandler.queue_instance.ClearWaypoints()
					%WaypointQueueHandler.QueueNewWaypoint(object.position)
					ship_movement.MoveShip()
					print("starbase found")
				elif HelperFunctions.CheckForObjectInGroup(object, "click_floors"):
					%WaypointQueueHandler.queue_instance.ClearWaypoints()
					%WaypointQueueHandler.QueueNewWaypoint(result["position"])
					ship_movement.MoveShip()
				else:
					SetShipTarget(result["collider"])
					print("target set")
				
		if event.is_action_pressed("QueueInteract") and !GlobalVariables.input_disabled:
			# determines what the mouse clicked on
			var result = DetermineClickSubject()
			
			# if the mouse clicked on something, check if its another ship or just the invisible floor
			if result != null:
				var object = result["collider"].get_parent()
				
				# if the mouse clicked the invisible floor, then create a waypoint
				if HelperFunctions.CheckForObjectInGroup(object, "hyperlane_relays"):
					print("you have clicked a relay!")
					object.get_parent().Warp(ship_node)
				# this conditional will fire if the object clicked is a ship. will be implemented later when the multiplayer is started
				elif HelperFunctions.CheckForObjectInGroup(object, "starbases"):
					object.get_node("ServiceContainer/DockComponent").AddQueuedDockingShip(ship_node)
					%WaypointQueueHandler.queue_instance.ClearWaypoints()
					%WaypointQueueHandler.QueueNewWaypoint(object.position)
					ship_movement.MoveShip()
					print("starbase found")
				elif HelperFunctions.CheckForObjectInGroup(object, "click_floors"):
					print(result)
					%WaypointQueueHandler.queue_instance.ClearWaypoints()
					%WaypointQueueHandler.QueueNewWaypoint(result["position"])
					ship_movement.MoveShip()
				else:
					SetShipTarget(result["collider"])
					print("target set")
			
func SetShipTarget(clicked_object) -> void:
	if HelperFunctions.CheckForObjectInGroup(clicked_object.get_parent(), "asteroids"):
		targeting_component.SetTarget(clicked_object.get_parent(), "asteroid")
	elif HelperFunctions.CheckForObjectInGroup(clicked_object.get_parent(), "ships"):
		targeting_component.SetTarget(clicked_object.get_parent(), "ship")
	elif HelperFunctions.CheckForObjectInGroup(clicked_object.get_parent(), "starbases"):
		targeting_component.SetTarget(clicked_object.get_parent(), "starbase")
	else:
		targeting_component.SetTarget(clicked_object.get_parent(), "other")

func DetermineClickSubject():
	
	var mouse_pos = get_viewport().get_mouse_position()
	var cam = GlobalVariables.camera
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	var targetable = true

	# starts the ray at the 3D world space position where a ray cast from the camera would originate
	ray_query.from = cam.project_ray_origin(mouse_pos)
	
	# end point is a normal vector in world space, representing the direction a ray would need to be cast from the camera's perspective to hit a specific point on the viewport plus the origin multiplied by the length of the ray
	ray_query.to = ray_query.from + cam.project_ray_normal(mouse_pos) * RAY_LENGTH
	
	# detects if anything intersects with the ray based on the ray query
	var result = space.intersect_ray(ray_query)
	#var targetables = get_nodes_in_group("targetables")
	print(result)
	if result == { }:
		return
		
	for group in result["collider"].get_parent().get_groups():
		print(group)
		if group == "untargetables":
			targetable = false
			
	for group in result["collider"].get_parent().get_groups():
		print(group)
		if group == "ships":
			if result["collider"].get_parent().id == ship_node.id:
				targetable = false
	
	# if the result isn't the player ship and the result exists
	# result["collider"].get_parent().id != ship_node.id and result != null and 
	if targetable or HelperFunctions.CheckForObjectInGroup(result["collider"].get_parent(), "click_floors"):
		print(result["collider"].get_parent())
		return result
	
	return 
