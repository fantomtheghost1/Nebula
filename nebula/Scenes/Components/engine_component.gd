extends Node3D

signal EngineEnabled(ship_node)
signal EngineDisabled(ship_node)
signal EngineDestroyed(ship_node)

enum STATUS {ENABLED, DISABLED, DESTROYED}

var component_status = STATUS.ENABLED
var hp = 0
var ship_engine_type = ""

const ENGINE_TYPES : Dictionary = {
	"DUMMY_MIN_ENGINE":{"ACCELERATION":10, "HP":100, "MAX_SPEED":0.2},
	"DUMMY_MAX_ENGINE":{"ACCELERATION":10000, "HP":100, "MAX_SPEED":0.05},
	"DUMMY_ZERO_ENGINE":{"ACCELERATION":0, "HP":0, "MAX_SPEED":0}
}

# sets the current shield generator that the instance is using
func SetEngine(engine_type : String) -> void:
	hp = ENGINE_TYPES[engine_type]["HP"]
	%ShipMovement.acceleration = ENGINE_TYPES[engine_type]["ACCELERATION"]
	%ShipMovement.max_speed = ENGINE_TYPES[engine_type]["MAX_SPEED"]
	ship_engine_type = engine_type
	EngineEnabled.emit(get_parent())
	print("engine set!")
		
func DamageComponent(damage) -> void:
	hp -= damage
	# if the component hp is depleted and the component hasn't been destroyed yet
	if hp <= 0 and component_status != STATUS.DESTROYED:
		DestroyComponent()
		
func EnableComponent() -> void:
	if component_status == STATUS.DISABLED:
		component_status = STATUS.ENABLED
		# generates a signal that passes the parent ship node as a parameter
		EngineEnabled.emit(get_parent())
	
func DisableComponent() -> void:
	if component_status == STATUS.ENABLED:
		component_status = STATUS.DISABLED
		# generates a signal that passes the parent ship node as a parameter
		EngineDisabled.emit(get_parent())

func DestroyComponent() -> void:
	component_status = STATUS.DESTROYED
	
	# generates a signal that passes the parent ship node as a parameter
	EngineDisabled.emit(get_parent())
	EngineDestroyed.emit(get_parent())
