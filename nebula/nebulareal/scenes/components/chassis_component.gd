extends Node3D


# Signal emitted when the chassis is destroyed, passing the parent ship node
signal ChassisDestroyed(ship_node)


# Chassis health and status variables
var max_hp : int = 0        # Maximum health points of the chassis
var hp : int = 0            # Current health points of the chassis
var chassis_name = ""       # Name of the chassis type
var destroyed : bool = false # Flag indicating if the chassis is destroyed


# Initializes the chassis with properties from a resource
func SetChassisType(resource : Resource):
	chassis_name = resource.ship_class
	hp = resource.max_hp
	max_hp = resource.max_hp
	if hp <= 0:
		DestroyComponent()


# Applies damage to the chassis component
func DamageComponent(damage) -> void:
	hp -= damage
	if hp <= 0 and !destroyed:
		DestroyComponent()


# Marks the chassis as destroyed and emits the ChassisDestroyed signal
func DestroyComponent() -> void:
	destroyed = true
	ChassisDestroyed.emit(get_parent())
