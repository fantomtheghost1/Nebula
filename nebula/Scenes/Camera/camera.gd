#                                         MAIN CAMERA
#################################################################################################
# This node allows the changing of camera subjects and tweens between the old and new subjects. # 
#################################################################################################

extends Node3D

signal Tweening
signal TweeningFinished

# this is the node that the camera focuses on
@export var subject : Node3D = null

# this sets the amount of time in seconds that the tween lasts
@export var new_subject_ease_duration : float = 0.0

var scanner_range : float

var tweening : bool = false

# starts the tween function and sets the camera subject
func SetTarget(new_subject : Node3D, tween : bool = true) -> void:
	subject = new_subject
	reparent(new_subject)
	if tween == true:
		TweenCamera(subject.position)
	
func InitScanner(range, zoom_max):
	scanner_range = range
	%ZoomComponent.SetMaxZoom(zoom_max)
	
# tweens the camera between the current position and the new, provided position
func TweenCamera(new_pos) -> void:
	tweening = true
	Tweening.emit()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_pos, new_subject_ease_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", on_tween_finished)
	
func on_tween_finished():
	TweeningFinished.emit()
	tweening = false
	
# sets the position of the camera to the subject if the subject is moving
func _physics_process(delta) -> void:
	if subject != null and !tweening:
		position = subject.position
		
