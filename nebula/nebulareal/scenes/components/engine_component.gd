extends Node3D


# Enum defining the engine's operational status
enum STATUS {ENABLED, DISABLED, CRIPPLED}


# Exported references to key components and nodes
@export var targeting_component : Node3D  # Component for targeting
@export var identity_component : Node3D   # Component for ship identity
@export var ship_model : Node3D           # Ship model node
@export var ship_node : Node3D            # Parent ship node


# Engine state and properties
var component_status = STATUS.ENABLED  # Current status of the engine
var hp = 0                            # Current health points
var engine_name = ""                  # Name of the engine type
var pid = 0                           # Player ID associated with the ship


# Initializes node references on ready
func _ready():
	%ClickHandler.targeting_component = targeting_component
	%ClickHandler.identity_component = identity_component
	%ClickHandler.ship_model = ship_model
	%ClickHandler.ship_node = ship_node
	%ShipMovement.Init(ship_node)


# Configures the engine with properties from a resource
func SetEngine(resource : Resource) -> void:
	engine_name = resource.name
	hp = resource.max_hp
	%ShipMovement.max_speed = resource.max_speed
	%ShipMovement.min_speed = resource.initial_speed
	%ShipMovement.current_speed = resource.initial_speed
	%ShipMovement.acceleration = resource.acceleration
	
	if hp > 0:
		EnableComponent()
	else:
		CrippleComponent()
	
	print_rich("[color=orange][Engine] Initialized: ", engine_name, "[/color]")


# Applies damage to the engine component
func DamageComponent(damage) -> void:
	hp -= damage
	if hp <= 0 and component_status != STATUS.CRIPPLED:
		CrippleComponent()


# Enables the engine if it is disabled
func EnableComponent() -> void:
	if component_status == STATUS.DISABLED:
		component_status = STATUS.ENABLED


# Disables the engine if it is enabled
func DisableComponent() -> void:
	if component_status == STATUS.ENABLED:
		component_status = STATUS.DISABLED


# Marks the engine as destroyed and emits signals
func CrippleComponent() -> void:
	print_rich("[color=purple]Ship %s\'s Engine Component Was Destroyed![/color]" % ship_node.name)
	component_status = STATUS.CRIPPLED
	%ShipMovement.max_speed = %ShipMovement.max_speed * 0.3
	%ShipMovement.min_speed = %ShipMovement.min_speed * 0.3
	%ShipMovement.current_speed = %ShipMovement.current_speed * 0.3
	%ShipMovement.acceleration = %ShipMovement.acceleration * 0.3
