extends Node3D

@export var pan_active = true
@onready var gimbal : Node3D = self.get_parent().get_parent()

# sets the speed at which the camera pans
const PAN_SENSITIVITY : float = 0.05 

var pan_velocity : Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("CameraPanUp"):
		pan_velocity = Vector3(pan_velocity.x, gimbal.position.y, -1.0 * PAN_SENSITIVITY)
	elif event.is_action_released("CameraPanUp"):
		pan_velocity = Vector3.ZERO
		
	if event.is_action_pressed("CameraPanDown"):
		pan_velocity = Vector3(pan_velocity.x, gimbal.position.y, 1.0 * PAN_SENSITIVITY)
	elif event.is_action_released("CameraPanDown"):
		pan_velocity = Vector3.ZERO
		
	if event.is_action_pressed("CameraPanLeft"):
		pan_velocity = Vector3(-1.0 * PAN_SENSITIVITY, gimbal.position.y, pan_velocity.z)
	elif event.is_action_released("CameraPanLeft"):
		pan_velocity = Vector3.ZERO
		
	if event.is_action_pressed("CameraPanRight"):
		pan_velocity = Vector3(1.0 * PAN_SENSITIVITY, gimbal.position.y, pan_velocity.z)
	elif event.is_action_released("CameraPanRight"):
		pan_velocity = Vector3.ZERO

func _process(_delta):
	if pan_velocity != Vector3.ZERO and pan_active:
		gimbal.position += pan_velocity
