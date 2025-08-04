extends MeshInstance3D

var deletion_queued = false

# Called when the life timer expires; removes this node from the scene
func _on_life_timer_timeout() -> void:
	if is_multiplayer_authority():
		DespawnLaser.rpc()

@rpc("call_local", "authority", "reliable")
func DespawnLaser():
	if !deletion_queued:
		get_parent().queue_free()
		deletion_queued = true
