extends Node3D

@export var target : MeshInstance3D = null

var dragging = false
var mouse_sens = 0.008

func _input(event):
	if event.is_action_pressed("CameraOrbitMode"):
		dragging = true
	
	if dragging and event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sens
	
	if event.is_action_released("CameraOrbitMode"):
		dragging = false

func _process(_delta):
	if target != null:
		position = target.position
