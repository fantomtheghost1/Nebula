extends Node3D

var ItemScript : Script = preload("res://Classes/Item.gd")

@export var ship_model : CharacterBody3D

var ship_name : String
var id : int = 0
var target : Node = null

func Initialize(username, ship_type, ship_id) -> void:
	id = ship_id
	ship_name = ship_type.name
	ship_model.set_collision_layer_value(1, true)
	ship_model.set_collision_layer_value(2, false)
	
	%ShieldGenerator.SetShieldGenerator(ship_type.shield_generator)
	%CargoComponent.SetCargoBay(ship_type.cargo_bay)
	%GeneratorComponent.SetGenerator(ship_type.generator)
	%ChassisComponent.SetChassisType(ship_type.chassis)
	%EngineComponent.SetEngine(ship_type.engine)
	%ScannerComponent.SetScanner(ship_type.scanner)
	
	if username != "AI":
		%IdentityComponent.SetOwner(username)
		%IdentityComponent.is_npc = false
	else: 
		%IdentityComponent.SetOwner(username)
		%IdentityComponent.is_npc = true
	
func SetTarget(new_target : Node):
	print_debug("new target set: " + str(new_target))
	target = new_target
	
func RemoveTarget():
	target = null
	
func DestroyShip():
	print_debug("ship destroyed")
	queue_free()
	
func _input(event):
	if event.is_action_pressed("DebugShipComponentStatus") and OS.is_debug_build():
		print_debug("\nShip " + str(id) + " Components Status")
		print_debug("----------------------")

		print_debug("Engine hp: " + str(%EngineComponent.hp))
		print_debug("Engine status: " + HelperFunctions.GetEnumStringFromIndex(%EngineComponent.STATUS, %EngineComponent.component_status))
			
		print_debug("\nShieldGenerator hp: " + str(%ShieldGenerator.hp))
		print_debug("ShieldGenerator status: " + HelperFunctions.GetEnumStringFromIndex(%ShieldGenerator.STATUS, %ShieldGenerator.component_status))
			
		print_debug("\nArmorComponent ap: " + str(%ArmorComponent.ap))
			
		print_debug("\nGeneratorComponent hp: " + str(%GeneratorComponent.hp))
		print_debug("GeneratorComponent status: " + HelperFunctions.GetEnumStringFromIndex(%GeneratorComponent.STATUS, %GeneratorComponent.component_status))

		print_debug("\nCargoComponent hp: " + str(%CargoComponent.hp))
		print_debug("CargoComponent status: " + HelperFunctions.GetEnumStringFromIndex(%CargoComponent.STATUS, %CargoComponent.component_status))
			
		print_debug("----------------------")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _on_chassis_component_chassis_destroyed(_ship_node):
	DestroyShip()

func _on_scanner_component_target_lost():
	RemoveTarget()
