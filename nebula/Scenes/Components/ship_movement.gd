extends Node3D

var acceleration = 0
var max_speed = 0
const RAY_LENGTH = 10000000000
@onready var click_floor_static = get_node("../../../../ClickFloor/StaticBody3D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):

	if event.is_action_pressed("Interact") and !Input.is_physical_key_pressed(KEY_ALT) and !Input.is_physical_key_pressed(KEY_SHIFT):
		var space_state = get_world_3d().direct_space_state
		var cam = get_node("../../../../CameraGimbal/Camera3D")

		%Raycast.position = cam.position
		%Raycast.target_position = cam.project_position(get_viewport().get_mouse_position(), position.z)
		
		print(%Raycast.target_position)
		
		if %Raycast.is_colliding():
			print(%Raycast.get_collider())
		
		
	if event.is_action_pressed("QueueInteract"):
		print("waypoint queued")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
