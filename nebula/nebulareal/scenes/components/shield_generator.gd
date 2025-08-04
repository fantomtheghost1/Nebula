extends Node3D

signal ShieldGeneratorDisabled
signal ShieldGeneratorEnabled

# Enum defining possible shield generator statuses
enum STATUS {ENABLED, DISABLED, CRIPPLED}


# Reference to the parent ship node
@export var ship_node : Node3D = null


# Health points of the shield generator
var hp : int = 0

# Name of the shield generator
var shield_name = ""

# Current status of the shield generator
var component_status = STATUS.ENABLED


# Initializes the shield bubble with the ship node reference
func _ready():
	%ShieldBubble.ship_node = ship_node


# Configures the shield generator with properties from a resource
func SetShieldGenerator(resource : Resource) -> void:
	shield_name = resource.name
	hp = resource.max_hp
	%ShieldBubble.max_sp = resource.max_sp
	%ShieldBubble.recharge_delay = resource.recharge_delay
	%ShieldBubble.recharge_tick = resource.recharge_tick
	%ShieldBubble.recharge_amount = resource.recharge_amount
	
	if hp > 0:
		EnableComponent()
	else:
		CrippleComponent()
	print_rich("[color=orange][ShieldGenerator] Initialized: ", shield_name, "[/color]")


# Applies damage to the shield generator and returns any overflow damage
func DamageComponent(damage) -> int:
	var overflow = 0
	if hp - damage < 0:
		overflow = (hp - damage) * -1
		hp = 0
	else:
		hp -= damage
	
	if hp <= 0 and component_status != STATUS.CRIPPLED:
		CrippleComponent()
	
	return overflow


# Enables the shield generator if it is disabled
func EnableComponent() -> void:
	if component_status == STATUS.DISABLED:
		component_status = STATUS.ENABLED
		%ShieldBubble.EnableShield()
		ShieldGeneratorEnabled.emit()

# Disables the shield generator if it is enabled
func DisableComponent() -> void:
	if component_status == STATUS.ENABLED:
		component_status = STATUS.DISABLED
		%ShieldBubble.DisableShield()
		ShieldGeneratorDisabled.emit()

# Marks the shield generator as destroyed and emits signals
func CrippleComponent() -> void:
	print_rich("[color=purple]Ship %s\'s Shield Generator Was Destroyed![/color]" % ship_node.name)
	component_status = STATUS.CRIPPLED
	%ShieldBubble.DisableShield()
