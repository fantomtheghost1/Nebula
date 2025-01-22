extends Node3D

var ItemScript : Script = preload("res://Classes/Item.gd")

@export var engine_component : Node3D = null

var id : int = 0

func Initialize(username, chassis_type, generator_type, cargo_bay_type, shield_generator_type, engine_type, ship_id) -> void:
	id = ship_id
	%ShieldGenerator.SetShieldGenerator(shield_generator_type)
	%CargoComponent.SetCargoBay(cargo_bay_type)
	%GeneratorComponent.SetGenerator(generator_type)
	%ChassisComponent.SetChassisType(chassis_type)
	%EngineComponent.SetEngine(engine_type)
	%IdentityComponent.SetOwner(username)
	
func DestroyShip():
	print("ship destroyed")
	queue_free()
	
func _input(event):
	if event.is_action_pressed("DebugShipComponentStatus") and OS.is_debug_build():
		print("\nShip " + str(id) + " Components Status")
		print("----------------------")

		print("Engine hp: " + str(%EngineComponent.hp))
		print("Engine status: " + HelperFunctions.GetEnumStringFromIndex(%EngineComponent.STATUS, %EngineComponent.component_status))
			
		print("\nShieldGenerator hp: " + str(%ShieldGenerator.hp))
		print("ShieldGenerator status: " + HelperFunctions.GetEnumStringFromIndex(%ShieldGenerator.STATUS, %ShieldGenerator.component_status))
			
		print("\nArmorComponent ap: " + str(%ArmorComponent.ap))
			
		print("\nGeneratorComponent hp: " + str(%GeneratorComponent.hp))
		print("GeneratorComponent status: " + HelperFunctions.GetEnumStringFromIndex(%GeneratorComponent.STATUS, %GeneratorComponent.component_status))

		print("\nCargoComponent hp: " + str(%CargoComponent.hp))
		print("CargoComponent status: " + HelperFunctions.GetEnumStringFromIndex(%CargoComponent.STATUS, %CargoComponent.component_status))
			
		print("----------------------")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _on_chassis_component_chassis_destroyed(_ship_node):
	DestroyShip()
