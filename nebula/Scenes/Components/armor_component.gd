extends Node3D

signal ArmorDestroyed(ship_node)

var ap : int = 0
var armor_type : String = ""
var destroyed : bool = false

const ARMOR_TYPES : Dictionary = {
	"DUMMY_MIN_ARMOR":{"AP":100},
	"DUMMY_MAX_ARMOR":{"AP":1000},
	"DUMMY_ZERO_ARMOR":{"AP":0}
}

func SetArmorType(armor : String):
	ap = ARMOR_TYPES[armor]["AP"]
	armor_type = armor

func DamageComponent(damage) -> void:
	ap -= damage
	# if the component ap is depleted and the component hasn't been destroyed yet
	if ap <= 0 and !destroyed:
		DestroyComponent()
		
func DestroyComponent() -> void:
	destroyed = true
	
	# generates a signal that passes the parent ship node as a parameter
	ArmorDestroyed.emit(get_parent())
