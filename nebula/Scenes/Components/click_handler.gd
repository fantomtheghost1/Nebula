extends Node3D

# holds references to the relavant waypoint classes
var Waypoint = preload("res://Classes/Waypoint.gd")
var WaypointQueue = preload("res://Classes/WaypointQueue.gd")

# set to a very high arbitrary number
const RAY_LENGTH = 10000000000

# holds important node references
var identity_component : Node3D = null
var ship_model : Node3D = null
@export var ship_movement : Node3D = null

func _ready():
	# initialize a new waypoint queue
	WaypointQueue = WaypointQueue.new()

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
					var waypoint = Waypoint.new(result["position"], true, GlobalVariables.main_scene)
					WaypointQueue.ClearWaypoints()
					WaypointQueue.Enqueue(waypoint)
					ship_movement.SetCurrentQueue(WaypointQueue)
					
					print("you clicked the floor at " + str(result["position"]))
				# this conditional will fire if the object clicked is a ship. will be implemented later when the multiplayer is started
				# elif GameManager.DoesShipExist(result["collider"].get_parent().id):
				#	print("clicked ship")
			
		if event.is_action_pressed("QueueInteract"):
			# determines what the mouse clicked on
			var result = DetermineClickSubject()
			
			# if the mouse clicked on something, check if its another ship or just the invisible floor
			if result != null:
				
				# if the mouse clicked the invisible floor, then create a waypoint
				if result["collider"].get_parent() == GlobalVariables.click_floor:
					var waypoint = Waypoint.new(result["position"], true, GlobalVariables.main_scene)
					ship_movement.current_queue.Enqueue(waypoint)
					
					print("you clicked the floor at " + str(result["position"]))
				# this conditional will fire if the object clicked is a ship. will be implemented later when the multiplayer is started
				#elif GameManager.DoesShipExist(result["collider"].get_parent().id):
				#	print("clicked ship")
			

func DetermineClickSubject():
	
	var mouse_pos = get_viewport().get_mouse_position()
	var cam = GlobalVariables.camera
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()

	# starts the ray at the 3D world space position where a ray cast from the camera would originate
	ray_query.from = cam.project_ray_origin(mouse_pos)
	
	# end point is a normal vector in world space, representing the direction a ray would need to be cast from the camera's perspective to hit a specific point on the viewport plus the origin multiplied by the length of the ray
	ray_query.to = ray_query.from + cam.project_ray_normal(mouse_pos) * RAY_LENGTH
	
	# detects if anything intersects with the ray based on the ray query
	var result = space.intersect_ray(ray_query)
	
	# if the result isn't the player ship and the result exists
	if result["collider"] != ship_model and result != null:
		return result
	
	return 
