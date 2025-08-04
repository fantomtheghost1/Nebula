extends Node3D

# Reference to the camera node being zoomed
@export var camera : Node3D = null

# Controls how fast the camera zooms in/out
const ZOOM_SENSITIVITY : float = 73

# Maximum allowed zoom distance (camera moves farther away)
var zoom_max : float = 20.0

# Minimum allowed zoom distance (camera moves closer)
const ZOOM_MIN : float = 2

# Prevents zoom input during tweening animations
var tweening : bool = false

# Allows setting the max zoom distance externally
func SetMaxZoom(max_zoom):
	zoom_max = max_zoom

func _input(event) -> void:
	if !tweening and !GlobalVariables.input_disabled:
		# Zoom in: move camera closer along X and Y if above minimum zoom
		if event.is_action_pressed("CameraZoomIn"):
			if camera.position.x > ZOOM_MIN:
				camera.position -= Vector3(1, 1, 0) * ZOOM_SENSITIVITY * get_physics_process_delta_time()
		
		# Zoom out: move camera farther along X and Y if below maximum zoom
		if event.is_action_pressed("CameraZoomOut"):
			if camera.position.x < zoom_max:
				camera.position += Vector3(1, 1, 0) * ZOOM_SENSITIVITY * get_physics_process_delta_time()
			else:
				pass

# Called when a tweening animation starts (disables zooming)
func _on_camera_gimbal_tweening():
	tweening = true

# Called when tweening animation ends (re-enables zooming)
func _on_camera_gimbal_tweening_finished():
	tweening = false
