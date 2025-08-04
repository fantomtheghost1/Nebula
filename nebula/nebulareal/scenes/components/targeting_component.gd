extends Node3D

var target : Node3D
var target_type : String
var previous_target : Node3D
var previous_target_type : String

func _process(_delta: float) -> void:
	if target != null:
		%TargetingReticle.position = GlobalVariables.camera.unproject_position(target.position) + Vector2(-11.5, -11.5)

func SetTarget(new_target : Node, target_type_param : String = ""):
	%TargetingReticle.show()
	target = new_target
	previous_target = null
	
	if target_type_param == "":
		target_type = previous_target_type
	else:
		target_type = target_type_param
		
	%ScannerComponent.target = target
	print_rich("[color=orange]Target Set!")
	
func RemoveTarget():
	%TargetingReticle.hide()
	previous_target = target
	previous_target_type = target_type
	target = null
	target_type = ""
	%ScannerComponent.previous_target = previous_target
	print_rich("[color=orange]Target Removed...")

func _on_scanner_component_target_found() -> void:
	if !target:
		%TargetingReticle.show()
		target = previous_target
		target_type = previous_target_type
		previous_target = null
		previous_target_type = ""
		print_rich("[color=orange]Previous Target %s Found!" % target.name)

func _on_scanner_component_target_lost() -> void:
	RemoveTarget()
