extends Node3D

signal EngineEnabled
signal EngineDisabled
signal EngineDestroyed

enum STATUS {ENABLED, DISABLED, DESTROYED}

@export var targeting_component : Node3D
@export var identity_component : Node3D
@export var ship_model : Node3D
@export var ship_node : Node3D

var component_status = STATUS.ENABLED
var hp = 0
var engine_name = ""

func _ready():
	%ClickHandler.targeting_component = targeting_component
	%ClickHandler.identity_component = identity_component
	%ClickHandler.ship_model = ship_model
	%ClickHandler.ship_node = ship_node
	%ShipMovement.ship_node = ship_node
	
# sets the current shield generator that the instance is using
func SetEngine(engine_type : EngineType) -> void:
	engine_name = engine_type.name
	hp = engine_type.max_hp
	%ShipMovement.max_speed = engine_type.max_speed
	%ShipMovement.min_speed = engine_type.initial_speed
	%ShipMovement.current_speed = engine_type.initial_speed
	%ShipMovement.acceleration = engine_type.acceleration
	
	if hp > 0:
		EnableComponent()
	else:
		DestroyComponent()
		
	print_debug("engine set!")
	
	#%ShipMovement.PathTo(Vector3(-100, 0, 100), 100, 5.0, 2)
	#%ShipMovement.MoveShip()
		
func DamageComponent(damage) -> void:
	hp -= damage
	# if the component hp is depleted and the component hasn't been destroyed yet
	if hp <= 0 and component_status != STATUS.DESTROYED:
		DestroyComponent()
		
func EnableComponent() -> void:
	if component_status == STATUS.DISABLED:
		component_status = STATUS.ENABLED
		# generates a signal that passes the parent ship node as a parameter
		EngineEnabled.emit()
	
func DisableComponent() -> void:
	if component_status == STATUS.ENABLED:
		component_status = STATUS.DISABLED
		# generates a signal that passes the parent ship node as a parameter
		EngineDisabled.emit()

func DestroyComponent() -> void:
	component_status = STATUS.DESTROYED
	
	# generates a signal that passes the parent ship node as a parameter
	EngineDisabled.emit()
	EngineDestroyed.emit()

func _on_ship_movement_ship_started_moving() -> void:
	print("ship " + %IdentityComponent.object_owner.name + " is moving!")

func _on_ship_movement_ship_stopped_moving() -> void:
	print("ship " + %IdentityComponent.object_owner.name + " stopped moving!")
