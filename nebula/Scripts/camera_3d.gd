extends Camera3D
@export var pan_sensitivity : float = 1.0
var pan_velocity : Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("PanUp"):
		pan_velocity = Vector3(0, 0, 1.0 * pan_sensitivity)
	if event.is_action_pressed("PanDown"):
		pan_velocity = Vector3(0, 0, -1.0 * pan_sensitivity)
	if event.is_action_pressed("PanUp"):
		pan_velocity = Vector3(1.0 * pan_sensitivity, 0, 0)
	if event.is_action_pressed("PanUp"):
		pan_velocity = Vector3(-1.0 * pan_sensitivity, 0, 0)
	else:
		pan_velocity = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pan_velocity != Vector3.ZERO:
		self.position += pan_velocity
