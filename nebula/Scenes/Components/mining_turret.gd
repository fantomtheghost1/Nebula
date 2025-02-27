extends Node3D

@export var id : int
@export var hp : int
@export var mining_speed : int
@export var targeting_component : Node3D
@export var cargo_component : Node3D

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
func SetTurret(turret_resource : Resource, turret_id : int, targeting_component_param : Node3D, cargo_component_param : Node3D):
	hp = turret_resource.hp
	id = turret_id
	mining_speed = turret_resource.mining_speed
	targeting_component = targeting_component_param
	cargo_component = cargo_component_param
	%MiningLaserRate.wait_time = turret_resource.mining_laser_rate
	
# deal damage to the asteroid and add the ore to the cargo hold
func FireLaser():
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
