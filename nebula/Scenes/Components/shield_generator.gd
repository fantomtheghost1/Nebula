extends Node3D

signal ShieldGeneratorEnabled(ship_node)
signal ShieldGeneratorDisabled(ship_node)
signal ShieldGeneratorDestroyed(ship_node)

# this enumerator holds all the possible statuses that the shield can be in
enum STATUS {ENABLED, DISABLED, DESTROYED}

# literally just health
var hp : int = 0

# represents the type of shield generator the instance is using
var shield_type : String = ""

# represents the current status of the shield generator
var component_status = STATUS.ENABLED

# stores all of the defined types of generators available in the game
# E.X. {"NAME" : {"MAX_POWER" : INT, "HP" : INT}}
const SHIELD_GENERATOR_TYPES : Dictionary = {
	"DUMMY_MIN_SHIELD_GENERATOR":{"MAX_SP":10, "HP":100, "RECHARGE_TICK":0.2, "RECHARGE_DELAY":3, "RECHARGE_AMOUNT":1},
	"DUMMY_MAX_SHIELD_GENERATOR":{"MAX_SP":10000, "HP":100, "RECHARGE_TICK":0.05, "RECHARGE_DELAY":1.5, "RECHARGE_AMOUNT":10},
	"DUMMY_ZERO_SHIELD_GENERATOR":{"MAX_SP":0, "HP":0, "RECHARGE_TICK":0, "RECHARGE_DELAY":0, "RECHARGE_AMOUNT":0}
}

# sets the current shield generator that the instance is using
func SetShieldGenerator(shield_generator_type : String) -> void:
	hp = SHIELD_GENERATOR_TYPES[shield_generator_type]["HP"]
	%ShieldBubble.max_sp = SHIELD_GENERATOR_TYPES[shield_generator_type]["MAX_SP"]
	%ShieldBubble.recharge_delay = SHIELD_GENERATOR_TYPES[shield_generator_type]["RECHARGE_DELAY"]
	%ShieldBubble.recharge_tick = SHIELD_GENERATOR_TYPES[shield_generator_type]["RECHARGE_TICK"]
	%ShieldBubble.recharge_amount = SHIELD_GENERATOR_TYPES[shield_generator_type]["RECHARGE_AMOUNT"]
	shield_type = shield_generator_type
	ShieldGeneratorEnabled.emit(get_parent())
	print("shield generator set!")
		
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
