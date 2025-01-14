extends Node3D

var dragging = false

func _input(event):
	if event.is_action_pressed("CameraOrbitMode"):
		dragging = true
	
	if dragging and InputEventMouseMotion:
		event.relative.x
	
	if event.is_action_released("CameraOrbitMode"):
		dragging = false
