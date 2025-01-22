extends Node3D

var Waypoint = preload("res://Classes/Waypoint.gd")
var WaypointQueue = preload("res://Classes/WaypointQueue.gd")

var acceleration = 0
var max_speed = 0
const RAY_LENGTH = 10000000000

var identity_component : Node3D = null
var ship_model : Node3D = null

func _ready():
	WaypointQueue = WaypointQueue.new()

func _input(event):

	# if the ship is owned by the client
	if identity_component.object_owner == "DEV":
		if event.is_action_pressed("Interact") and !Input.is_physical_key_pressed(KEY_ALT) and !Input.is_physical_key_pressed(KEY_SHIFT):
			
			# determines what the mouse clicked on
			var result = DetermineClickSubject()
			
			# if the mouse clicked on something, check if its another ship or just the invisible floor
			if result != null:
				
				# if the mouse clicked the invisible floor, then create a waypoint
				if result["collider"].get_parent() == GlobalVariables.click_floor:
					var waypoint = Waypoint.new(result["position"], true, self)
					WaypointQueue.ClearWaypoints()
					WaypointQueue.Enqueue(waypoint)
					print("you clicked the floor at " + str(result["position"]))
				#elif GameManager.DoesShipExist(result["collider"].get_parent().id):
				#	print("clicked ship")
			
		if event.is_action_pressed("QueueInteract"):
			# determines what the mouse clicked on
			var result = DetermineClickSubject()
			
			print(result)

func DetermineClickSubject():
	var mouse_pos = get_viewport().get_mouse_position()
	var cam = GlobalVariables.camera
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()

	ray_query.from = cam.project_ray_origin(mouse_pos)
	ray_query.to = ray_query.from + cam.project_ray_normal(mouse_pos) * RAY_LENGTH
	
	var result = space.intersect_ray(ray_query)
	
	if result["collider"] != ship_model:
		return result
	
	return 
