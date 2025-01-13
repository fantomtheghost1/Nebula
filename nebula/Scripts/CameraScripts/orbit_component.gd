extends Node3D

@onready var gimbal : Node3D = self.get_parent().get_parent()
@onready var target = gimbal.target

const MOUSE_SENSITIVITY = 1.0

var dragging = false

func _input(event):
	if event.is_action_pressed("CameraOrbitMode"):
		dragging = true
		%PanComponent.pan_active = false
		get_parent().position = Vector3(target.position.x, 10, target.position.z)
		
	if event is InputEventMouseMotion and dragging:
		gimbal.rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		gimbal.rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		gimbal.rotation.x = clamp(gimbal.rotation.x, -PI/2.0, PI/2.0)
		print(gimbal.rotation)
		
	if event.is_action_released("CameraOrbitMode"):
		dragging = false
		%PanComponent.pan_active = true
