extends Node3D

signal ChassisDestroyed(ship_node)

var hp : int = 0
var chassis_name = ""
var destroyed : bool = false

func SetChassisType(chassis_type : ChassisType):
	chassis_name = chassis_type.name
	hp = chassis_type.hp
	if hp <= 0:
		DestroyComponent()

func DamageComponent(damage) -> void:
	hp -= damage
	# if the component hp is depleted and the component hasn't been destroyed yet
	if hp <= 0 and !destroyed:
		DestroyComponent()
		
func DestroyComponent() -> void:
	destroyed = true
	
	# generates a signal that passes the parent ship node as a parameter
	ChassisDestroyed.emit(get_parent())
