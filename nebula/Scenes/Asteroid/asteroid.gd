extends Node3D

var object_type : String = "asteroid"
var composition : Resource
var ore_max : int
var ore : int
var hovering : bool = false

@export var id : int = 0
@export var resource : Resource

func _ready():
	if id != 0 and resource != null:
		Initialize(id, resource)

func Initialize(param_id, asteroid_type) -> void: 
	id = param_id
	composition = asteroid_type.composition
	ore = asteroid_type.ore
	ore_max = ore
	resource = asteroid_type
	
	if asteroid_type.model != null:
		var model = asteroid_type.model.instantiate()
		%ModelContainer.add_child(model)
		
	scale = scale * Vector3(asteroid_type.scale, asteroid_type.scale, asteroid_type.scale)

func TakeDamage(damage : int):
	var ore_yield = 0
	ore -= damage
	
	if ore <= 0:
		ore_yield = ore + damage
		queue_free()
	else:
		var new_scale_factor : float = float(ore) / float(ore_max)
		scale = scale * (0.95)
		
	return {
		"ore_yield": damage,
		"composition": composition
	}
	
func _process(delta: float) -> void:
	if hovering:
		%TooltipLabel.position = GlobalVariables.camera.unproject_position(position) + Vector2(-131, 0)

func _on_static_body_3d_mouse_entered() -> void:
	%TooltipLabel.visible = true
	hovering = true
	match resource.scale:
		1.0:
			%TooltipLabel.text = "Small " + composition.name + " Asteroid"
		2.0:
			%TooltipLabel.text = "Medium " + composition.name + " Asteroid"
		3.0:
			%TooltipLabel.text = "Large " + composition.name + " Asteroid"
		4.0:
			%TooltipLabel.text = "Massive " + composition.name + " Asteroid"
	print("showing tooltip")

func _on_static_body_3d_mouse_exited() -> void:
	%TooltipLabel.visible = false
	hovering = false
	print("hiding tooltip")
