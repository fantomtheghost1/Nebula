extends Node3D

var laser = preload("res://scenes/projectile/laser.tscn")

@export var id : int
@export var hp : int
@export var mining_speed : int
@export var targeting_component : Node3D
@export var cargo_component : Node3D
@export var ship_node : Node3D
@export var laser_spawn : Node3D

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
	hp = turret_resource.hp
	id = turret_id
	mining_speed = turret_resource.mining_speed
	targeting_component = targeting_component_param
	cargo_component = cargo_component_param
	laser_spawn = laser_spawn_param
	ship_node = parent_ship
	%MiningLaserRate.wait_time = turret_resource.mining_laser_rate
	
# create a laser mesh, deal damage to the asteroid, and add the ore to the cargo hold
func FireLaser():
	var laser_instance = laser.instantiate()
	laser_spawn.add_child(laser_instance)
	laser_instance.mesh.height = HelperFunctions.GetDistanceBetweenTwoPoints(ship_node.position, targeting_component.target.position)
	
	var results = targeting_component.target.TakeDamage(mining_speed)
	cargo_component.AddCargo(results["composition"], results["ore_yield"])
	print_debug(HelperFunctions.GetEnumStringFromIndex(Item.ITEMS, results["composition"]) + " += " + str(results["ore_yield"]))
	print_debug(cargo_component.GetCargo())
	
# when the mining laser delay ends, fire a laser, otherwise, if the target is destroyed, deactivate the turret
func _on_mining_laser_rate_timeout() -> void:
	if targeting_component.target != null and targeting_component.target_type == "asteroid":
		FireLaser()
		%MiningLaserRate.start()
	else: 
		ToggleActivated()
