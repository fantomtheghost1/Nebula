#                                       ZOOM COMPONENT
###############################################################################################
# This component creates the camera zoom that occurs when the player scrolls the mouse wheel. # 
###############################################################################################

extends Node3D

# for readability
@export var camera : Node3D = null

# sets the speed at which the camera zooms
const ZOOM_SENSITIVITY : float = 73

# sets the maximum that the camera can zoom
var zoom_max : float = 20.0

# sets the minimum that the camera can zoom
const ZOOM_MIN : float = 2

var tweening : bool = false

func SetMaxZoom(max_zoom):
	zoom_max = max_zoom

func _input(event) -> void:
	
	if !tweening:
		# if the player scrolls the mouse wheel, change the current zoom
		if event.is_action_pressed("CameraZoomIn"):
			if camera.position.x > ZOOM_MIN:
				camera.position = camera.position - Vector3(1, 1, 0) * ZOOM_SENSITIVITY * get_physics_process_delta_time()
		if event.is_action_pressed("CameraZoomOut"):
			if camera.position.x < zoom_max:
				camera.position = camera.position + Vector3(1, 1, 0) * ZOOM_SENSITIVITY * get_physics_process_delta_time()
			else:
				print("at max")

func _on_camera_gimbal_tweening():
	tweening = true

func _on_camera_gimbal_tweening_finished():
	tweening = false
