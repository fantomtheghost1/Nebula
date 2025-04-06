extends Node3D

var object_type = "starbase"
var starbase_id : int

func _init(resource : Resource, id : int) -> void:
	starbase_id = id
	
	%ShieldGenerator.SetShieldGenerator(resource.shield_generator)
	%CargoComponent.SetCargoBay(resource.cargo_bay)
	%GeneratorComponent.SetGenerator(resource.generator)
	%ScannerComponent.SetScanner(resource.scanner)
	
	for i in resource.turret_slots:
		print("created new turret")
		#var new_turret = mining_turret_scene.instantiate()
		#new_turret.SetTurret(ship_type.mining_turret, i + 1, self, %TargetingComponent, %CargoComponent, %LaserSpawn)
		#new_turret.name = "MiningTurret" + str(i + 1)
		#%MiningContainer.add_child(new_turret)
		
	#%MiningContainer.number_of_turrets = ship_type.turret_slots
