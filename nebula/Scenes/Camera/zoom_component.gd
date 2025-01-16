#                                       ZOOM COMPONENT
###############################################################################################
# This component creates the camera zoom that occurs when the player scrolls the mouse wheel. # 
###############################################################################################

extends Node3D

# for readability
@onready var camera : Node3D = get_parent()

# sets the speed at which the camera zooms
const ZOOM_SENSITIVITY : float = 1.0

# sets the maximum that the camera can zoom
const ZOOM_MAX : float = 20.0

# sets the minimum that the camera can zoom
const ZOOM_MIN : float = 5.0

# the current zoom value
var zoom_value : float = 8.0

func _input(event) -> void:
	# if the player scrolls the mouse wheel, change the current zoom
	if event.is_action_pressed("CameraZoomIn"):
		zoom_value -= ZOOM_SENSITIVITY
	if event.is_action_pressed("CameraZoomOut"):
		zoom_value += ZOOM_SENSITIVITY

# Called every frame. This clamps the current zoom value and sets the camera's y position to the zoom value
func _process(_delta) -> void:
	if camera.position.y != zoom_value:
		if zoom_value > ZOOM_MAX:
			zoom_value = ZOOM_MAX
		if zoom_value < ZOOM_MIN:
			zoom_value = ZOOM_MIN
		camera.position = Vector3(camera.position.x, zoom_value, camera.position.z)
