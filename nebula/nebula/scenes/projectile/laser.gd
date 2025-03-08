extends MeshInstance3D

func _on_life_timer_timeout() -> void:
	queue_free()
