extends Node3D

signal ShieldGeneratorEnabled(ship_node)
signal ShieldGeneratorDisabled(ship_node)
signal ShieldGeneratorDestroyed(ship_node)

# this enumerator holds all the possible statuses that the shield can be in
enum STATUS {ENABLED, DISABLED, DESTROYED}

@export var ship_node : Node3D = null

# literally just health
var hp : int = 0

# represents the name of shield generator the instance is using
var shield_name = ""

# represents the current status of the shield generator
var component_status = STATUS.ENABLED


func _ready():
	%ShieldBubble.ship_node = ship_node

# sets the current shield generator that the instance is using
func SetShieldGenerator(shield_generator_type : ShieldGeneratorType) -> void:
	shield_name = shield_generator_type.name
	hp = shield_generator_type.max_hp
	%ShieldBubble.max_sp = shield_generator_type.max_sp
	%ShieldBubble.recharge_delay = shield_generator_type.recharge_delay
	%ShieldBubble.recharge_tick = shield_generator_type.recharge_tick
	%ShieldBubble.recharge_amount = shield_generator_type.recharge_amount
	
	if hp > 0:
		EnableComponent()
	else:
		DestroyComponent()
	print_debug("shield generator set!")
		
func DamageComponent(damage) -> void:
	hp -= damage
	# if the component hp is depleted and the component hasn't been destroyed yet
	if hp <= 0 and component_status != STATUS.DESTROYED:
		DestroyComponent()
		
func EnableComponent() -> void:
	if component_status == STATUS.DISABLED:
		component_status = STATUS.ENABLED
		# generates a signal that passes the parent ship node as a parameter
		ShieldGeneratorEnabled.emit(get_parent())
	
func DisableComponent() -> void:
	if component_status == STATUS.ENABLED:
		component_status = STATUS.DISABLED
		# generates a signal that passes the parent ship node as a parameter
		ShieldGeneratorDisabled.emit(get_parent())

func DestroyComponent() -> void:
	component_status = STATUS.DESTROYED
	
	# generates a signal that passes the parent ship node as a parameter
	ShieldGeneratorDisabled.emit(get_parent())
	ShieldGeneratorDestroyed.emit(get_parent())
