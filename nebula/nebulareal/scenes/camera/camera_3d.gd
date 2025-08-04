extends Camera3D

# Reference to the camera gimbal node controlling orientation and target
@export var camera_gimbal : Node3D

# Flag indicating whether a tweening animation is in progress
var is_tweening = false

func _process(_delta):
	# If not tweening and a subject exists, make the camera look at the subject
	if !is_tweening and camera_gimbal.has_subject:
		var point = camera_gimbal.subject.global_transform.origin
		self.look_at(Vector3(point.x, point.y, point.z), Vector3.UP)
	# If no subject exists, default the camera's look direction to the origin
	elif camera_gimbal.subject == null:
		self.look_at(Vector3(0, 0, 0), Vector3.UP)

# Called when the camera gimbal starts tweening (e.g., during smooth transitions)
func _on_camera_gimbal_tweening():
	is_tweening = true

# Called when the camera gimbal finishes tweening
func _on_camera_gimbal_tweening_finished():
	is_tweening = false
