extends Node3D

# rework scanner component to handle detecting wrecks and starbases in the area

signal TargetFound
signal TargetLost

@export var scanner_range : float
@export var object_fade_in : float
@onready var IdentityComponent : Node3D = %IdentityComponent

var target : Node
var previous_target : Node

func SetScanner(scanner_type):
	scanner_range = scanner_type.scanner_range
	%Area3D.scale = Vector3(scanner_range, scanner_range, scanner_range)

func _on_area_3d_body_entered(body):
	#body.get_node("MeshInstance3D").mesh.material.transparency = 0
	#var tween = create_tween()
	#tween.tween_property(body.get_node("MeshInstance3D"), "mesh:material:albedo_color:a", 1, object_fade_in)
	if IdentityComponent.object_owner != "AI":
		body.get_parent().visible = true
		
	print("body entered scanner area: " + body.get_parent().name)
	body.get_parent().add_to_group("targetables")
	
	if HelperFunctions.CheckForObjectInGroup(body.get_parent(), "wrecks"):
		%SalvagerComponent.AddWreckInRadius(body.get_parent())
		
	if body.get_parent() == previous_target:
		TargetFound.emit()
	#body.get_node("MeshInstance3D").modulate()
	
func _on_area_3d_body_exited(body):
	#var tween = create_tween()
	#tween.tween_property(body.get_node("MeshInstance3D"), "mesh:material:albedo_color:a", 0, object_fade_in)
	#print("body exited scanner area: " + body.get_parent().name)
	if IdentityComponent.object_owner != "AI":
		body.get_parent().visible = false
		
	body.get_parent().remove_from_group("targetables")
	if body.get_parent() == target:
		TargetLost.emit()
