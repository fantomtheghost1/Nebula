#                                       ORBIT COMPONENT
#################################################################################################
# This component creates the camera orbit motion that occurs when the player holds right click. # 
#################################################################################################

extends Node3D

var button_is_held = false
var mouse_sens = 0.008

func _input(event):
	if event.is_action_pressed("CameraOrbitMode"):
		button_is_held = true
	
	# if the player is holding the right mouse button and dragging the mouse, then apply the orbit movement
	if button_is_held and event is InputEventMouseMotion:
		get_parent().get_parent().rotation.y -= event.relative.x * mouse_sens
		print(position)
	
	if event.is_action_released("CameraOrbitMode"):
		button_is_held = false
