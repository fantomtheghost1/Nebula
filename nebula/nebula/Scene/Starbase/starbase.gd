extends Node3D

@export var hull = 0
@onready var shield_gen : Node3D = get_node_or_null("ShieldGenerator")

# Called when the node enters the scene tree for the first time.
func _ready():
	if shield_gen != null:
		print("shield generator online")
		#print(shield_gen.TakeDamage(1000))
	else:
		print("shield generator not installed...")

#func TakeDamage(damage):
	
