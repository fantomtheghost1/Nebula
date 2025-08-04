extends Node3D

signal turret_state_changed(turret : Node3D)

# Preloaded laser projectile scene
var laser = preload("res://scenes/projectile/laser_beam.tscn")


# Turret properties
@export var id : int                     # Unique identifier for the turret
@export var hp : int                     # Health points of the turret
@export var damage : int                 # Damage dealt to asteroids
@export var fire_rate : float            # The rate of fire that the laser fires at


# References to ship components
@export var targeting_component : Node3D  # Component for selecting targets
@export var cargo_component : Node3D      # Component for storing mined resources
@export var ship_node : Node3D            # Parent ship node
@export var beam_color : Color            # Color of the turret's laser beam
@export var laser_spawn : Node3D          # Node where the laser visual is spawned


# Turret state flags
var firing_laser = false                  # Prevents multiple simultaneous laser firings

# Enum defining the turret's operational status
enum STATUS {ENABLED, DISABLED, CRIPPLED}

var turret_status = STATUS.DISABLED


# Toggles the turret's activation state
func Activate():
	turret_status = STATUS.ENABLED
	turret_state_changed.emit(self)
	
	print_rich("[color=orange][Turret ", id, "] Activated![/color]")
	%MiningLaserRate.start()
	
func Deactivate():
	turret_status = STATUS.DISABLED
	turret_state_changed.emit(self)
	print_rich("[color=orange][Turret ", id, "] Deactivated![/color]")
	%MiningLaserRate.stop()

# Configures the turret's properties from a resource
func SetTurret(resource_max_hp : int, resource_damage : int, resource_fire_rate : float, resource_beam_color : Color):
	hp = resource_max_hp
	damage = resource_damage
	beam_color = resource_beam_color
	%MiningLaserRate.wait_time = resource_fire_rate
	fire_rate = resource_fire_rate


# Handles firing the mining laser when the timer expires
func _on_mining_laser_rate_timeout() -> void:
	if targeting_component.target != null and targeting_component.target_type == "asteroid" and turret_status == STATUS.ENABLED:
		if not cargo_component.IsCargoHoldFull() and not firing_laser:
			firing_laser = true
			HelperFunctions.CreateLaser.rpc_id(1, ship_node.id, targeting_component.target.global_position, beam_color)
			var results = targeting_component.target.TakeDamage(damage)
			cargo_component.AddCargo(results["composition"], results["ore_yield"])
			%MiningLaserRate.start()
			firing_laser = false
		else:
			Deactivate()
	else:
		Deactivate()
	
func DamageTurret(param_damage) -> void:
	hp -= param_damage
	if hp <= 0:
		CrippleTurret()

func CrippleTurret():
	print_rich("[color=purple]Ship %s\'s Turret %s Was Destroyed![/color]" % [ship_node.name, id])
	turret_state_changed.emit(self)
	turret_status = STATUS.CRIPPLED
	damage = roundi(damage * 0.3)
	hp = 0
