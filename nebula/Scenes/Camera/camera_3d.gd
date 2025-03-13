extends Camera3D

var is_tweening = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !is_tweening and GlobalVariables.camera_gimbal.subject != null:
		var point = GlobalVariables.camera_gimbal.subject.global_transform.origin
		self.look_at(Vector3(point.x, point.y, point.z), Vector3.UP)
	elif GlobalVariables.camera_gimbal.subject == null:
		self.look_at(Vector3(0, 0, 0), Vector3.UP)

func _on_camera_gimbal_tweening():
	is_tweening = true

func _on_camera_gimbal_tweening_finished():
	is_tweening = false
