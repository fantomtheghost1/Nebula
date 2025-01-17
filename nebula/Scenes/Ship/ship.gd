extends Node3D

var ItemScript : Script = preload("res://Classes/Item.gd")

var ship_id : int = 0

func Initialize(chassis_type, generator_type, cargo_bay_type, shield_generator_type, id) -> void:
	ship_id = id
	%ShieldGenerator.SetShieldGenerator(shield_generator_type)
	%CargoComponent.SetCargoBay(cargo_bay_type)
	%GeneratorComponent.SetGenerator(generator_type)
	%IdentityComponent.SetOwner("test " + str(ship_id))
	%ChassisComponent.SetChassisType(chassis_type)
	%ChassisComponent.DamageComponent(1)
	self.name = str(ship_id)
	

	
func DestroyShip():
	print("ship destroyed")
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _on_chassis_component_chassis_destroyed(ship_node):
	DestroyShip()
