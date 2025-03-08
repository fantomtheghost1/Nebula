extends Node3D

signal ArmorDestroyed(ship_node)

var ap : int = 0
var armor_name = ""
var destroyed : bool = false

func SetArmorType(armor_type : ArmorType):
	armor_name = armor_type.name
	ap = armor_type.ap

func DamageComponent(damage) -> void:
	ap -= damage
	# if the component ap is depleted and the component hasn't been destroyed yet
	if ap <= 0 and !destroyed:
		DestroyComponent()
		
func DestroyComponent() -> void:
	destroyed = true
	
	# generates a signal that passes the parent ship node as a parameter
	ArmorDestroyed.emit(get_parent())
