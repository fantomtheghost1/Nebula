extends Node3D

signal turret_state_changed(turret : Node3D)

# Unique identifier for the mining turret
@export var id : int

# Health points of the turret
@export var hp : int

# Damage dealt to asteroids by the turret
@export var damage : int

# Accuracy of the turret's attacks (0.0 to 1.0)
@export var accuracy : float

# References to key components and properties
@export var targeting_component : Node3D  # Component for selecting targets
@export var ship_node : Node3D            # Parent ship node
@export var salvager_component : Node3D   # Component for handling salvaged resources
@export var beam_color : Color            # Color of the turret's laser beam


# Enum defining the turret's operational status
enum STATUS {ENABLED, DISABLED, CRIPPLED}

var turret_status = STATUS.DISABLED # Current status of the turret


# Toggles the turret's activation state
func Activate():
	turret_state_changed.emit(self)
	turret_status = STATUS.ENABLED
	print_rich("[color=orange][Turret ", id, "] Activated![/color]")
	
	%FireRate.start()
	
func Deactivate():
	turret_status = STATUS.DISABLED
	turret_state_changed.emit(self)
	print_rich("[color=orange][Turret ", id, "] Deactivated![/color]")
	%FireRate.stop()

# Configures the turret's properties from a resource
func SetTurret(resource_max_hp : int, resource_damage : int, resource_accuracy : float, resource_fire_rate : float, resource_beam_color : Color):
	hp = resource_max_hp
	damage = resource_damage
	accuracy = resource_accuracy
	beam_color = resource_beam_color
	%FireRate.wait_time = resource_fire_rate


# Called when the fire rate timer expires
func _on_fire_rate_timeout() -> void:
	if turret_status == STATUS.ENABLED:
		if targeting_component.target:
			if targeting_component.target_type == "ship":
				var target_faction = targeting_component.target.get_node("IdentityComponent").object_owner.faction_name
				
				# Fire at non-allied ships or starbases
				if not GlobalVariables.faction_container.AreFactionsAllied(ship_node.identity_comp.GetOwner().faction_name, target_faction) or targeting_component.target_type == "starbase":
					HelperFunctions.CreateLaser.rpc_id(1, ship_node.id, targeting_component.target.global_position, beam_color)
					targeting_component.target.TakeDamage.rpc(damage, accuracy)
					%FireRate.start()
					return
	
	# Deactivate turret if no valid target
	Deactivate()
	
func DamageTurret(param_damage) -> void:
	hp -= param_damage
	if hp <= 0:
		CrippleTurret()

func CrippleTurret():
	print_rich("[color=purple]Ship %s\'s Turret %s Was Destroyed![/color]" % [ship_node.name, id])
	turret_status = STATUS.CRIPPLED
	turret_state_changed.emit(self)
	damage = roundi(damage * 0.3)
	accuracy = 0.25
	hp = 0
