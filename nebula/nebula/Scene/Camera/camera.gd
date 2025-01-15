#                                         MAIN CAMERA
#################################################################################################
# This node allows the changing of camera subjects and tweens between the old and new subjects. # 
#################################################################################################

extends Node3D

# this is the node that the camera focuses on
@export var subject : Node3D = null

# this sets the amount of time in seconds that the tween lasts
@export var new_subject_ease_duration = 0.0

var tweening = false

# starts the tween function and sets the camera subject
func SetTarget(new_subject):
	TweenCamera(new_subject.position)
	subject = new_subject
	
# tweens the camera between the current position and the new, provided position
func TweenCamera(new_pos):
	tweening = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_pos, new_subject_ease_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tweening = false
	
# sets the position of the camera to the subject if the subject is moving
func _process(_delta):
	if subject != null and !tweening:
		position = subject.position
