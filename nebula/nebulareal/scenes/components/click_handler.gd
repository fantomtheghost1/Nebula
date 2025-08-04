extends Node3D


# Constant for raycasting length used in click detection
const RAY_LENGTH = 10000000000


# References to key nodes in the ship hierarchy
var ship_node : Node3D              # The main ship node
var ship_model : Node3D             # The ship model node
var identity_component : Node3D     # Component storing ship identity data


# Exported nodes for targeting and movement components
@export var targeting_component : Node3D
@export var ship_movement : Node3D
@export var visible_waypoints : bool  # Toggle for waypoint visibility


# Handles input events for ship interactions
func _input(event):
	# Only process input for the local player's ship
	if ship_node.id != multiplayer.multiplayer_peer.get_unique_id():
		return
	
	# Handle primary interaction (Interact action without Alt or Shift)
	if event.is_action_pressed("Interact") and !Input.is_physical_key_pressed(KEY_ALT) and !Input.is_physical_key_pressed(KEY_SHIFT) and !GlobalVariables.input_disabled:
		var result = DetermineClickSubject()
		if result != null:
			var object = result["collider"].get_parent()
			
			if HelperFunctions.CheckForObjectInGroup(object, "hyperlane_relays"):
				object.Warp.rpc(str(ship_node.get_path()))
			elif HelperFunctions.CheckForObjectInGroup(object, "starbases"):
				object.get_node("ServiceContainer/DockComponent").AddQueuedDockingShip(ship_node)
				%WaypointQueueHandler.queue_instance.ClearWaypoints()
				%WaypointQueueHandler.QueueNewWaypoint(object.position)
				ship_movement.MoveShip()
			elif HelperFunctions.CheckForObjectInGroup(object, "click_floors"):
				if HostFunctions.CheckWaypointPlacement(ship_node.position, result["position"]):
					%WaypointQueueHandler.queue_instance.ClearWaypoints()
					%WaypointQueueHandler.QueueNewWaypoint(result["position"])
					ship_movement.MoveShip()
			else:
				SetShipTarget(result["collider"])
	
	# Handle queued interaction (QueueInteract action)
	if event.is_action_pressed("QueueInteract") and !GlobalVariables.input_disabled:
		var result = DetermineClickSubject()
		if result != null:
			var object = result["collider"].get_parent()
			
			if HelperFunctions.CheckForObjectInGroup(object, "hyperlane_relays"):
				object.get_parent().Warp.rpc(str(ship_node.get_path()))
			elif HelperFunctions.CheckForObjectInGroup(object, "starbases"):
				object.get_node("ServiceContainer/DockComponent").AddQueuedDockingShip(ship_node)
				%WaypointQueueHandler.queue_instance.ClearWaypoints()
				%WaypointQueueHandler.QueueNewWaypoint(object.position)
				ship_movement.MoveShip()
			elif HelperFunctions.CheckForObjectInGroup(object, "click_floors"):
				if HostFunctions.CheckWaypointPlacement(ship_node.position, result["position"]):
					%WaypointQueueHandler.queue_instance.ClearWaypoints()
					%WaypointQueueHandler.QueueNewWaypoint(result["position"])
					ship_movement.MoveShip()
			else:
				SetShipTarget(result["collider"])


# Sets the target for the ship's targeting component based on clicked object
func SetShipTarget(clicked_object) -> void:
	var parent = clicked_object.get_parent()
	if HelperFunctions.CheckForObjectInGroup(parent, "asteroids"):
		targeting_component.SetTarget(parent, "asteroid")
	elif HelperFunctions.CheckForObjectInGroup(parent, "ships"):
		targeting_component.SetTarget(parent, "ship")
	elif HelperFunctions.CheckForObjectInGroup(parent, "starbases"):
		targeting_component.SetTarget(parent, "starbase")
	else:
		targeting_component.SetTarget(parent, "other")


# Determines what object was clicked using a raycast
func DetermineClickSubject():
	var mouse_pos = get_viewport().get_mouse_position()
	var cam = GlobalVariables.camera
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	var targetable = true
	
	# Set raycast origin and direction based on mouse position
	ray_query.from = cam.project_ray_origin(mouse_pos)
	ray_query.to = ray_query.from + cam.project_ray_normal(mouse_pos) * RAY_LENGTH
	
	# Perform raycast to detect collisions
	var result = space.intersect_ray(ray_query)
	if result.is_empty():
		return null
	
	# Check if the collided object is untargetable
	for group in result["collider"].get_parent().get_groups():
		if group == "untargetables":
			targetable = false
	
	# Prevent targeting the player's own ship
	for group in result["collider"].get_parent().get_groups():
		if group == "ships" and result["collider"].get_parent().id == ship_node.id:
			targetable = false
	
	# Return result if the object is targetable or is a click floor
	if targetable or HelperFunctions.CheckForObjectInGroup(result["collider"].get_parent(), "click_floors"):
		return result
	
	return null
