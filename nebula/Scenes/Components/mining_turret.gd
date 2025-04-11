extends Node3D

# preload the turret laser projectile
var laser = preload("res://scenes/projectile/laser.tscn")

# represents the id of the mining turret
@export var id : int

# represents the hp of the turret
@export var hp : int

# represents the damage the turret does to an asteroid
@export var damage : int

# these variables hold references to various components within the ship
@export var targeting_component : Node3D
@export var cargo_component : Node3D
@export var ship_node : Node3D

# holds an instance of the visual laser model
@export var laser_spawn : Node3D

# determines whether the turret is activated and ready to fire at a target
var activated = false

func ToggleActivated():
	activated = !activated
	
	if activated:
		print_debug("turret " + str(id) + " activated")
		%MiningLaserRate.start()
	else:
		print_debug("turret " + str(id) + " deactivated")
		%MiningLaserRate.stop()

# configures the turret when the ship is created
func SetTurret(turret_resource : Resource, turret_id : int, parent_ship : Node3D, targeting_component_param : Node3D, cargo_component_param : Node3D, laser_spawn_param : Node3D):
	hp = turret_resource.max_hp
	id = turret_id
	damage = turret_resource.damage
	targeting_component = targeting_component_param
	cargo_component = cargo_component_param
	laser_spawn = laser_spawn_param
	ship_node = parent_ship
	%MiningLaserRate.wait_time = turret_resource.mining_laser_rate
	
func FireLaser():
	
	# create a laser mesh and position it accordingly
	var laser_instance = laser.instantiate()
	laser_spawn.add_child(laser_instance)
	laser_instance.mesh.height = HelperFunctions.GetDistanceBetweenTwoPoints(ship_node.position, targeting_component.target.position)
	
	# deal damage to the asteroid and add the ore to the cargo hold
	var results = targeting_component.target.TakeDamage(damage)
	cargo_component.AddCargo(results["composition"], results["ore_yield"])
	print_debug(results["composition"].name + " += " + str(results["ore_yield"]))
	print_debug(cargo_component.GetCargo())
	
# when the mining laser delay ends, fire a laser, otherwise, if the target is destroyed, deactivate the turret
func _on_mining_laser_rate_timeout() -> void:
	if targeting_component.target != null and targeting_component.target_type == "asteroid":
		if !cargo_component.IsCargoHoldFull():
			FireLaser()
			%MiningLaserRate.start()
		else: 
			ToggleActivated()
	else: 
		ToggleActivated()
