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
@export var ship_node : Node3D
@export var salvager_component : Node3D

# holds an instance of the visual laser model
@export var laser_spawn : Node3D

# determines whether the turret is activated and ready to fire at a target
var activated = false

func ToggleActivated():
	activated = !activated
	print("Turret " + str(id) + " Activation Toggled")
	
	if activated:
		%FireRate.start()
	else:
		%FireRate.stop()

# configures the turret when the ship is created
func SetTurret(turret_resource : Resource, turret_id : int, parent_ship : Node3D, targeting_component_param : Node3D, laser_spawn_param : Node3D, salvager_component_param : Node3D):
	hp = turret_resource.max_hp
	id = turret_id
	damage = turret_resource.damage
	targeting_component = targeting_component_param
	salvager_component = salvager_component_param
	laser_spawn = laser_spawn_param
	ship_node = parent_ship
	%FireRate.wait_time = turret_resource.fire_rate
	
func FireLaser():
	
	# create a laser mesh and position it accordingly
	var laser_instance = laser.instantiate()
	laser_spawn.add_child(laser_instance)
	laser_instance.mesh.height = HelperFunctions.GetDistanceBetweenTwoPoints(ship_node.position, targeting_component.target.position)
	
	# deal damage to the asteroid and add the ore to the cargo hold
	targeting_component.target.TakeDamage(damage)
	
func _on_fire_rate_timeout() -> void:
	if targeting_component.target != null and targeting_component.target_type == "ship" or targeting_component.target_type == "starbase":
		FireLaser()
		%FireRate.start()
	else: 
		ToggleActivated()
