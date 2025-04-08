extends Node3D

var ItemScript : Script = preload("res://classes/Item.gd")

var combat_turret_scene = preload("res://scenes/components/combat_turret.tscn")
var mining_turret_scene = preload("res://scenes/components/mining_turret.tscn")
var shot_hit_text = preload("res://shot_hit_text.tscn")

@export var ship_model : CharacterBody3D

var object_type = "ship"
var dock_in_radius : Node3D
var can_dock : bool = false
var damagable_components = 8
var rng = RandomNumberGenerator.new()

@export var is_ai : bool = false
@export var ship_type : Resource
@export var id : int = 0
@export var ship_owner : String

func _ready():
	if ship_owner != "" and id != 0 and ship_type != null:
		Initialize(is_ai, ship_type, id, ship_owner)
		if !is_ai:
			%CameraGimbal.SetTarget(self, false)
			%CameraGimbal.InitScanner(ship_type.scanner.scanner_range, ship_type.scanner.zoom_max)	

func Initialize(is_ai : bool, ship_type_param, ship_id, captain_name : String = "AI") -> void:
	id = ship_id
	ship_type = ship_type_param
	
	#add_to_group("untargetables")
	
	%ShieldGenerator.SetShieldGenerator(ship_type.shield_generator)
	%CargoComponent.SetCargoBay(ship_type.cargo_bay)
	%GeneratorComponent.SetGenerator(ship_type.generator)
	%ChassisComponent.SetChassisType(ship_type.chassis)
	%EngineComponent.SetEngine(ship_type.engine)
	%ScannerComponent.SetScanner(ship_type.scanner)
	
	if is_ai:
		%IdentityComponent.SetOwner("AI")
		%IdentityComponent.is_npc = true
	else:
		%IdentityComponent.SetOwner(captain_name)
		%IdentityComponent.is_npc = false
		ship_model.set_collision_layer_value(1, true)
		ship_model.set_collision_layer_value(2, false)
		
		if GlobalVariables.camera_gimbal != null:
			GlobalVariables.camera_gimbal.SetTarget(self, false)
			GlobalVariables.camera_gimbal.InitScanner(ship_type.scanner.scanner_range, ship_type.scanner.zoom_max)		
	%ShipAIComponent.CheckIsAI(%IdentityComponent.is_npc)
	
	for i in ship_type.turret_slots:
		if ship_type.mining_turret != null:
			var new_turret = mining_turret_scene.instantiate()
			new_turret.SetTurret(ship_type.mining_turret, i + 1, self, %TargetingComponent, %CargoComponent, %LaserSpawn)
			new_turret.name = "MiningTurret" + str(i + 1)
			%MiningContainer.add_child(new_turret)
			%MiningContainer.number_of_turrets = ship_type.turret_slots
			
		if ship_type.combat_turret != null:
			var new_turret = combat_turret_scene.instantiate()
			new_turret.SetTurret(ship_type.combat_turret, i + 1, self, %TargetingComponent, %LaserSpawn)
			new_turret.name = "CombatTurret" + str(i + 1)
			%CombatContainer.add_child(new_turret)
			%CombatContainer.number_of_turrets = ship_type.turret_slots
		
	damagable_components += ship_type.turret_slots
	
func GetOwner():
	return %IdentityComponent.object_owner
		
func GetCargo():
	return %CargoComponent.GetCargo()
	
func IsCargoHoldEmpty():
	return %CargoComponent.IsCargoHoldEmpty()
	
func ClearCargo():
	%CargoComponent.ClearCargo()
	
func SetOwner(new_owner : String):
	%IdentityComponent.SetOwner(new_owner)
	if new_owner == "AI":
		%IdentityComponent.is_npc = true
		
func TakeDamage(damage : int, is_command : bool = false):
	var chassis_hit_chance : float = 25
	if !is_command:
		if rng.randf_range(0, 100) <= chassis_hit_chance:
			%ChassisComponent.DamageComponent(damage)
			print("chassis hit for " + str(damage) + " damage!")
			
			var new_text = shot_hit_text.instantiate()
			%ShotHit.add_child(new_text)
			new_text.text = "Shot hit for " + str(damage) + " damage!"
			new_text.label_settings.font_color = Color(1, 0.26, 0.31, 1)
		else:
			var new_text = shot_hit_text.instantiate()
			%ShotHit.add_child(new_text)
			new_text.text = "Shot missed!"
			new_text.label_settings.font_color = Color(1, 1, 1, 1)
	else:
		%ChassisComponent.DamageComponent(damage)
		print("chassis hit for " + str(damage) + " damage!")
	
func DestroyShip():
	print_debug("ship destroyed")
	
	queue_free()

func _on_chassis_component_chassis_destroyed(_ship_node):
	DestroyShip()
