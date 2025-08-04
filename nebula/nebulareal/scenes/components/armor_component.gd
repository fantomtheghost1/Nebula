extends Node3D

@export var parent_node : Node3D

# Armor points and status variables
var ap : int = 0           # Current armor points
var armor_name = ""        # Name of the armor type
var crippled : bool = false  # Flag indicating if armor is crippled


# Sets the armor type and initializes properties
func SetArmorType(armor_type : ArmorType):
	armor_name = armor_type.name
	ap = armor_type.ap


# Applies damage to the armor component
func DamageComponent(damage) -> void:
	ap -= damage
	if ap <= 0 and !crippled:
		CrippleComponent()


# Marks the armor as destroyed and emits the ArmorDestroyed signal
func CrippleComponent() -> void:
	print_rich("[color=purple]Ship %s\'s Armor Component Was Destroyed![/color]" % parent_node.name)
	crippled = true
	ap = 0
