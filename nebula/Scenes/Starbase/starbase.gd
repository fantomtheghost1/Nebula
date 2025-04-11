extends Node3D

var object_type : String = "starbase"
var starbase_type : String = ""
var station_name : String = "Epsilon"

@export var starbase_id : int = 0
@export var starbase_resource : Resource

func _ready():
	if starbase_resource != null and starbase_id != 0:
		Initialize(starbase_resource, starbase_id)

func Initialize(resource : Resource, id : int) -> void:
	starbase_id = id
	starbase_type = resource.starbase_type
	
	%ShieldGenerator.SetShieldGenerator(resource.shield_generator)
	%CargoComponent.Initialize(resource.cargo_bay)
	%GeneratorComponent.SetGenerator(resource.generator)
	%ScannerComponent.SetScanner(resource.scanner)
	
	for i in resource.turret_slots:
		print("created new turret")
		#var new_turret = mining_turret_scene.instantiate()
		#new_turret.SetTurret(ship_type.mining_turret, i + 1, self, %TargetingComponent, %CargoComponent, %LaserSpawn)
		#new_turret.name = "MiningTurret" + str(i + 1)
		#%MiningContainer.add_child(new_turret)
		
	#%MiningContainer.number_of_turrets = ship_type.turret_slots
	
	%WelcomeLabel.text = "Welcome to " + starbase_type + " " + station_name + "!"

func _on_deposit_materials_pressed() -> void:
	if !%DockComponent.docked_ships[0].IsCargoHoldEmpty():
		var new_cargo = %DockComponent.docked_ships[0].GetCargo()
		%DockComponent.docked_ships[0].ClearCargo()
		for item in new_cargo:
			%CargoComponent.AddCargo(new_cargo[item].item, new_cargo[item].quantity)
	else:
		print("Cargo Hold is empty!")
