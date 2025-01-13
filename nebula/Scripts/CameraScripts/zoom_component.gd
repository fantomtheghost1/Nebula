extends Node3D

@onready var gimbal : Node3D = self.get_parent().get_parent()

# sets the speed at which the camera zooms
const ZOOM_SENSITIVITY : float = 4.0

# sets the maximum that the camera can zoom
const ZOOM_MAX : float = 50.0

# sets the minimum that the camera can zoom
const ZOOM_MIN : float = 5.0

var zoom_value : float = ZOOM_MIN

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("CameraZoomIn"):
		zoom_value -= ZOOM_SENSITIVITY
	if event.is_action_pressed("CameraZoomOut"):
		zoom_value += ZOOM_SENSITIVITY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if gimbal.position.z != zoom_value:
		if zoom_value > ZOOM_MAX:
			zoom_value = ZOOM_MAX
		if zoom_value < ZOOM_MIN:
			zoom_value = ZOOM_MIN
		gimbal.position = Vector3(gimbal.position.x, zoom_value, gimbal.position.z)
