extends Node3D

@export var ship_node : Node3D
@export var engine_component : Node3D
@export var shield_generator : Node3D
@export var mining_container : Node3D
@export var combat_container : Node3D

# Name of the current generator
var generator_name = ""

# Maximum power output of the generator
var max_power : int = 1

# Health points of the generator
var hp : int = 1

# Enum defining the generator's operational status
enum STATUS {ENABLED, DISABLED, CRIPPLED}

# Current status of the generator
var component_status = STATUS.ENABLED


# Initializes the generator with properties from a resource
func SetGenerator(resource : Resource) -> void:
	generator_name = resource.name
	max_power = resource.max_power
	hp = resource.max_hp
	
	if hp > 0:
		component_status = STATUS.ENABLED
	else:
		CrippleComponent()
	
	print_rich("[color=orange][Generator] Initialized: ", generator_name, "[/color]")


# Applies damage to the generator component
func DamageComponent(damage) -> void:
	hp -= damage
	if hp <= 0 and component_status != STATUS.CRIPPLED:
		CrippleComponent()


# Marks the generator as destroyed and emits the destruction signal
func CrippleComponent() -> void:
	component_status = STATUS.CRIPPLED
	engine_component.CrippleComponent()
	shield_generator.CrippleComponent()
	mining_container.CrippleTurrets()
	combat_container.CrippleTurrets()
