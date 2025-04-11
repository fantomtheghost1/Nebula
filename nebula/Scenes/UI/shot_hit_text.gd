extends Label

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(232, 145), rng.randf_range(1.5, 3)) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

func _on_death_timer_timeout() -> void:
	queue_free()
