extends Node3D

# set to a very high arbitrary number
const RAY_LENGTH = 10000000000

# holds important node references
var identity_component : Node3D
var ship_model : Node3D
@export var targeting_component : Node3D
@export var ship_movement : Node3D
@export var visible_waypoints : bool

func _input(event):

	# if the ship is owned by the client
	if identity_component.object_owner == "DEV":
		
		# this will fire when the client presses the interact action without holding alt or shift
		if event.is_action_pressed("Interact") and !Input.is_physical_key_pressed(KEY_ALT) and !Input.is_physical_key_pressed(KEY_SHIFT):
			
			# determines what the mouse clicked on
			var result = DetermineClickSubject()
			# if the mouse clicked on something, check if its another ship or just the invisible floor
			if result != null:
				
				# if the mouse clicked the invisible floor, then create a waypoint 
				# and reset the current queue in ship movement so that the waypoint 
				# the ship is moving to is changed
				if result["collider"].get_parent() == GlobalVariables.click_floor:
					%WaypointQueueHandler.queue_instance.ClearWaypoints()
					%WaypointQueueHandler.QueueNewWaypoint(result["position"])
					ship_movement.MoveShip()
					
				# this conditional will fire if the object clicked is a ship. will be implemented later when the multiplayer is started
				else:
					SetShipTarget(result["collider"])
			
		if event.is_action_pressed("QueueInteract"):
			# determines what the mouse clicked on
			var result = DetermineClickSubject()
			
			# if the mouse clicked on something, check if its another ship or just the invisible floor
			if result != null:
				
				# if the mouse clicked the invisible floor, then create a waypoint
				if result["collider"].get_parent() == GlobalVariables.click_floor:
					
					# if the queue is empty, start the MoveShip() recursive loop
					if %WaypointQueueHandler.queue_instance.IsEmpty():
						%WaypointQueueHandler.QueueNewWaypoint(result["position"])
						ship_movement.MoveShip()
					else:
						%WaypointQueueHandler.QueueNewWaypoint(result["position"])
					
					
				# this conditional will fire if the object clicked is a ship. will be implemented later when the multiplayer is started
				else:
					SetShipTarget(result["collider"])
			
			
func SetShipTarget(clicked_object) -> void:
	if HelperFunctions.CheckForObjectInGroup(clicked_object.get_parent(), "asteroids"):
		targeting_component.SetTarget(clicked_object.get_parent(), "asteroid")
	else:
		targeting_component.SetTarget(clicked_object.get_parent(), "other")

func DetermineClickSubject():
	
	var mouse_pos = get_viewport().get_mouse_position()
	var cam = GlobalVariables.camera
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	var targetable = false

	# starts the ray at the 3D world space position where a ray cast from the camera would originate
	ray_query.from = cam.project_ray_origin(mouse_pos)
	
	# end point is a normal vector in world space, representing the direction a ray would need to be cast from the camera's perspective to hit a specific point on the viewport plus the origin multiplied by the length of the ray
	ray_query.to = ray_query.from + cam.project_ray_normal(mouse_pos) * RAY_LENGTH
	
	# detects if anything intersects with the ray based on the ray query
	var result = space.intersect_ray(ray_query)
	#var targetables = get_nodes_in_group("targetables")
	for group in result["collider"].get_parent().get_groups():
		if group != "untargetables":
			targetable = true
	
	# if the result isn't the player ship and the result exists
	if result["collider"] != ship_model and result != null and targetable or result["collider"].get_parent() == GlobalVariables.click_floor:
		return result
	
	return 
