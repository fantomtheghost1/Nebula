# Manages a camera that tracks a subject in the game
# Extends Node3D to position the camera in a 3D scene
extends Node3D

# Signal emitted when the camera starts tweening to a new position
signal Tweening
# Signal emitted when the camera finishes tweening
signal TweeningFinished

# Indicates whether the camera is currently tracking a subject
var has_subject : bool = false
# Reference to the subject (Node3D) being tracked, set via the editor or script
@export var subject : Node3D = null

# The range within which the scanner can operate
var scanner_range : float

# Tracks whether the camera is currently tweening to a new position
var tweening : bool = false

# Sets a new subject for the camera to track and optionally tweens to its position
# Parameters:
# - new_subject: The Node3D to track
# - tween: If true, smoothly transition to the subject's position
func SetTarget(new_subject : Node3D, tween : bool = true) -> void:
	# Update subject tracking status and reference
	has_subject = true
	subject = new_subject
	# Reparent the camera to the subject, deferred to avoid scene tree issues
	call_deferred("reparent", new_subject)
	# If tweening is enabled, smoothly move to the subject's position
	if tween == true:
		TweenCamera(subject.position)

# Initializes the scanner with a range and maximum zoom
# Parameters:
# - param_range: The operational range of the scanner
# - zoom_max: The maximum zoom level for the ZoomComponent
func InitScanner(param_range, zoom_max):
	# Set the scanner's range
	scanner_range = param_range
	# Configure the maximum zoom for the ZoomComponent node
	%ZoomComponent.SetMaxZoom(zoom_max)

# Smoothly transitions the camera to a new position using a tween
# Parameters:
# - new_pos: The target position (Vector3) to move to
func TweenCamera(new_pos) -> void:
	# Set tweening state and emit signal
	tweening = true
	Tweening.emit()
	# Create a new tween for smooth movement
	var tween = get_tree().create_tween()
	# Tween the camera's position to the new position over a global duration
	tween.tween_property(self, "position", new_pos, GlobalVariables.generic_tween_time) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	# Connect the tween's finished signal to the completion handler
	tween.connect("finished", on_tween_finished)

# Called when the tweening process completes
func on_tween_finished():
	# Emit signal to indicate tweening is complete
	TweeningFinished.emit()
	# Reset tweening state
	tweening = false

# Updates the camera's position each physics frame
# Parameters:
# - delta: Time elapsed since the last frame
func _physics_process(_delta) -> void:
	# If a subject is set and not tweening, instantly follow the subject's position
	if subject != null and !tweening:
		position = subject.position
