extends Node3D

var target : Node3D
var target_type : String
var previous_target : Node3D
var previous_target_type : String

func SetTarget(new_target : Node, target_type_param : String = ""):
	print_debug("new target set: " + new_target.name)
	target = new_target
	previous_target = null
	
	if target_type_param == "":
		target_type = previous_target_type
	else:
		target_type = target_type_param
		
	%ScannerComponent.target = target
	
func RemoveTarget():
	previous_target = target
	previous_target_type = target_type
	target = null
	target_type = ""
	%ScannerComponent.previous_target = previous_target
	print("target removed: " + previous_target.name)

func _on_scanner_component_target_found() -> void:
	if !target:
		target = previous_target
		target_type = previous_target_type
		previous_target = null
		previous_target_type = ""
		print("previous target found: " + target.name)

func _on_scanner_component_target_lost() -> void:
	RemoveTarget()
