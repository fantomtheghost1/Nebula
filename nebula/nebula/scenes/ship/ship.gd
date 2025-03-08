extends Node3D

var ItemScript : Script = preload("res://classes/Item.gd")

var mining_turret_scene = preload("res://scenes/components/mining_turret.tscn")

@export var ship_model : CharacterBody3D

var ship_type : Resource
var ship_name : String
var id : int = 0

func Initialize(username, ship_type_param, ship_id) -> void:
	id = ship_id
	ship_type = ship_type_param
	ship_name = ship_type.name
	ship_model.set_collision_layer_value(1, true)
	ship_model.set_collision_layer_value(2, false)
	
	#add_to_group("untargetables")
	
	%ShieldGenerator.SetShieldGenerator(ship_type.shield_generator)
	%CargoComponent.SetCargoBay(ship_type.cargo_bay)
	%GeneratorComponent.SetGenerator(ship_type.generator)
	%ChassisComponent.SetChassisType(ship_type.chassis)
	%EngineComponent.SetEngine(ship_type.engine)
	%ScannerComponent.SetScanner(ship_type.scanner)
	
	if username != "AI":
		%IdentityComponent.SetOwner(username)
		%IdentityComponent.is_npc = false
		#add_child(GlobalVariables.camera_gimbal)
		GlobalVariables.camera_gimbal.SetTarget(self, false)
		GlobalVariables.camera_gimbal.InitScanner(ship_type.scanner.scanner_range, ship_type.scanner.zoom_max)
	else: 
		%IdentityComponent.SetOwner(username)
		%IdentityComponent.is_npc = true
		
	%ShipAIComponent.CheckIsAI(%IdentityComponent.is_npc)
	
	for i in ship_type.mining_turret_count:
		var new_turret = mining_turret_scene.instantiate()
		new_turret.SetTurret(ship_type.mining_turret, i + 1, self, %TargetingComponent, %CargoComponent, %LaserSpawn)
		new_turret.name = "MiningTurret" + str(i + 1)
		%MiningContainer.add_child(new_turret)
		
	%MiningContainer.number_of_turrets = ship_type.mining_turret_count
	
func GetOwner():
	return %IdentityComponent.object_owner
	
func SetOwner(new_owner : String):
	%IdentityComponent.SetOwner(new_owner)
	if new_owner == "AI":
		%IdentityComponent.is_npc = true
	
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

func _on_chassis_component_chassis_destroyed(_ship_node):
	DestroyShip()
