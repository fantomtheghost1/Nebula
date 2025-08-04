extends Node3D

# Flag to track whether the orbit button is being held
var button_is_held = false

# Mouse sensitivity for camera orbit movement
var mouse_sens = 0.008

func _input(event) -> void:
	# Activate orbit mode when the designated input is pressed
	if event.is_action_pressed("CameraOrbitMode"):
		button_is_held = true

	# Rotate the camera around the Y axis while the orbit button is held and the mouse moves
	if button_is_held and event is InputEventMouseMotion and !GlobalVariables.input_disabled:
		GlobalVariables.camera_gimbal.rotation.y -= event.relative.x * mouse_sens

	# Deactivate orbit mode when the input is released
	if event.is_action_released("CameraOrbitMode"):
		button_is_held = false
