#                         GENERATOR COMPONENT
###########################################################################
# This component replicates the behavior of a generator in a ship or base # 
###########################################################################

extends Node3D

# emited when the component is destroyed
signal GeneratorDestroyed(ship_node)

# stores the generator type the instance is currently using
var generator_type : String = ""

# sets the maximum power the generator can produce
var max_power : int = 1

# literally just health
var hp : int = 1

# represents whether the component is destroyed or not
enum STATUS {ENABLED, DISABLED, DESTROYED}

var component_status = STATUS.ENABLED

# stores all of the defined types of generators available in the game
# E.X. {"NAME" : {"MAX_POWER" : INT, "HP" : INT}}
const GENERATOR_TYPES : Dictionary = {"DUMMY_MAX_GENERATOR":{"MAX_POWER":1000, "HP": 100},
					"DUMMY_MIN_GENERATOR":{"MAX_POWER":100, "HP": 100},
					"DUMMY_ZERO_GENERATOR":{"MAX_POWER":0, "HP":0}}

# sets the current generator that the instance is using
func SetGenerator(new_generator_type : String) -> void:
	max_power = GENERATOR_TYPES[new_generator_type]["MAX_POWER"]
	hp = GENERATOR_TYPES[new_generator_type]["HP"]
	print("generator set!")
	
func DamageComponent(damage) -> void:
	hp -= damage
	# if the component hp is depleted and the component hasn't been destroyed yet
	if hp <= 0 and component_status != STATUS.DESTROYED:
		DestroyComponent()

func DestroyComponent() -> void:
	component_status = STATUS.DESTROYED
	
	# generates a signal that passes the parent ship node as a parameter
	GeneratorDestroyed.emit(get_parent())
