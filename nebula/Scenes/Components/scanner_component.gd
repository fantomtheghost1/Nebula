extends Node3D

# rework scanner component to handle detecting wrecks and starbases in the area

signal TargetFound
signal TargetLost

@export var parent_node : Node3D
@export var scanner_range : float
@export var object_fade_in : float
@export var IdentityComponent : Node3D

var target : Node
var previous_target : Node
var objects_in_range : Array

func SetScanner(scanner_type):
	scanner_range = scanner_type.scanner_range
	%Area3D.scale = Vector3(scanner_range, scanner_range, scanner_range)

func _on_area_3d_body_entered(body):
	#body.get_node("MeshInstance3D").mesh.material.transparency = 0
	#var tween = create_tween()
	#tween.tween_property(body.get_node("MeshInstance3D"), "mesh:material:albedo_color:a", 1, object_fade_in)
	if !HelperFunctions.CheckForObjectInGroup(parent_node, "starbases"):
		if IdentityComponent.object_owner.is_ai != true and !HelperFunctions.CheckForObjectInGroup(body.get_parent(), "always_visible"):
			objects_in_range.append(body.get_parent())
			body.get_parent().visible = true
	if HelperFunctions.CheckForObjectInGroup(body.get_parent(), "wrecks"):
		%SalvagerComponent.AddWreckInRadius(body.get_parent())
		
	if body.get_parent() == previous_target:
		TargetFound.emit()
	#body.get_node("MeshInstance3D").modulate()
	
func _on_area_3d_body_exited(body):
	#var tween = create_tween()
	#tween.tween_property(body.get_node("MeshInstance3D"), "mesh:material:albedo_color:a", 0, object_fade_in)
	#print("body exited scanner area: " + body.get_parent().name)
	if !HelperFunctions.CheckForObjectInGroup(parent_node, "starbases"):
		if IdentityComponent.object_owner.is_ai != true:
			if HelperFunctions.CheckForObjectInGroup(body.get_parent(), "ships"):
				print_debug(body.get_parent())
				if body.get_parent() != GameManager.GetClientShip():
					body.get_parent().visible = false
					objects_in_range.erase(body.get_parent())
			else:
				if !HelperFunctions.CheckForObjectInGroup(body.get_parent(), "always_visible"):
					body.get_parent().visible = false
					objects_in_range.erase(body.get_parent())
		
	body.get_parent().remove_from_group("targetables")
	if body.get_parent() == target:
		TargetLost.emit()
			
	
