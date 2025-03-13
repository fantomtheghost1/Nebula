#                         GENERATOR COMPONENT
###########################################################################
# This component replicates the behavior of a generator in a ship or base # 
###########################################################################

extends Node3D

# emited when the component is destroyed
signal GeneratorDestroyed(ship_node)

# stores the generator name the instance is currently using
var generator_name = ""

# sets the maximum power the generator can produce
var max_power : int = 1

# literally just health
var hp : int = 1

# represents whether the component is destroyed or not
enum STATUS {ENABLED, DISABLED, DESTROYED}

var component_status = STATUS.ENABLED

# sets the current generator that the instance is using
func SetGenerator(generator_type : GeneratorType) -> void:
	generator_name = generator_type.name
	max_power = generator_type.max_power
	hp = generator_type.max_hp
	
	if hp > 0:
		component_status = STATUS.ENABLED 
	else:
		DestroyComponent()
		
	print_debug("generator set!")
	
func DamageComponent(damage) -> void:
	hp -= damage
	# if the component hp is depleted and the component hasn't been destroyed yet
	if hp <= 0 and component_status != STATUS.DESTROYED:
		DestroyComponent()

func DestroyComponent() -> void:
	component_status = STATUS.DESTROYED
	
	# generates a signal that passes the parent ship node as a parameter
	GeneratorDestroyed.emit(get_parent())
