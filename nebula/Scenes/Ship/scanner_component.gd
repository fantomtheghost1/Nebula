extends Node3D

signal TargetFound()
signal TargetLost()
signal TargetDestroyed()

@export var scanner_range : float
@export var ship_node : Node3D
@export var ship_model : Node3D
@export var object_fade_in : float

var target : Node
var previous_target : Node

func SetScanner(scanner_type):
	scanner_range = scanner_type.scanner_range
	%Area3D.scale = Vector3(scanner_range, scanner_range, scanner_range)

func _on_area_3d_body_entered(body):
	#body.get_node("MeshInstance3D").mesh.material.transparency = 0
	var tween = create_tween()
	tween.tween_property(body.get_node("MeshInstance3D"), "mesh:material:albedo_color:a", 1, object_fade_in)
	print("body entered scanner area: " + body.get_parent().name)
	body.get_parent().add_to_group("targetables")
	if body.get_parent() == previous_target:
		TargetFound.emit()
	#body.get_node("MeshInstance3D").modulate()
	
func _on_area_3d_body_exited(body):
	var tween = create_tween()
	tween.tween_property(body.get_node("MeshInstance3D"), "mesh:material:albedo_color:a", 0, object_fade_in)
	print("body exited scanner area: " + body.get_parent().name)
	body.get_parent().remove_from_group("targetables")
	if body.get_parent() == target:
		TargetLost.emit()
