extends Node3D

signal EngineEnabled(ship_node)
signal EngineDisabled(ship_node)
signal EngineDestroyed(ship_node)

enum STATUS {ENABLED, DISABLED, DESTROYED}

@export var identity_component : Node3D = null
@export var ship_model : Node3D = null
@export var ship_node : Node3D = null

var component_status = STATUS.ENABLED
var hp = 0
var engine_name = ""

func _ready():
	%ClickHandler.identity_component = identity_component
	%ClickHandler.ship_model = ship_model
	%ClickHandler.ship_node = ship_node
	%ShipMovement.ship_node = ship_node
	#%WaypointQueueHandler.bt_player = bt_player 
	
# sets the current shield generator that the instance is using
func SetEngine(engine_type : EngineType) -> void:
	engine_name = engine_type.name
	hp = engine_type.hp
	%ShipMovement.max_speed = engine_type.max_speed
	
	if hp > 0:
		EnableComponent()
	else:
		DestroyComponent()
		
	print_debug("engine set!")
		
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
