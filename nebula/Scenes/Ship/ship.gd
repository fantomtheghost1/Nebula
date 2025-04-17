extends Node3D

var wreck = preload("res://scenes/wreck/wreck.tscn")
var combat_turret_scene = preload("res://scenes/components/combat_turret.tscn")
var mining_turret_scene = preload("res://scenes/components/mining_turret.tscn")
var shot_hit_text = preload("res://scenes/UI/shot_hit_text.tscn")

var object_type : String = "ship"
var damagable_components : int = 8
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var docked : bool = false
var can_dock : bool = false
var is_repaired : bool = true
var dock_in_radius : Node3D

@export var ship_model : CharacterBody3D
@export var is_ai : bool = false
@export var resource : Resource
@export var id : int = 0

func _ready():
	if SteamManager.client.name != "" and id != 0 and resource != null:
		Initialize(is_ai, resource, id, SteamManager.client.name)
		if !is_ai:
			%CameraGimbal.SetTarget(self, false)
			%CameraGimbal.InitScanner(resource.scanner.scanner_range, resource.scanner.zoom_max)	

func Initialize(is_ai : bool, ship_type, ship_id, captain_name : String = "AI") -> void:
	id = ship_id
	resource = ship_type
	
	#add_to_group("untargetables")
	if resource.model != null:
		var model = resource.model.instantiate()
		model.scale = Vector3(30, 30, 30)
		get_node("ShipModel").add_child(model)
		%MeshInstance3D.queue_free()
		
	%ShieldGenerator.SetShieldGenerator(resource.shield_generator)
	%CargoComponent.Initialize(resource.cargo_bay)
	%GeneratorComponent.SetGenerator(resource.generator)
	%ChassisComponent.SetChassisType(resource.chassis)
	%EngineComponent.SetEngine(resource.engine)
	%ScannerComponent.SetScanner(resource.scanner)
	
	if is_ai:
		%IdentityComponent.SetOwner(CaptainManager.FindAvailableAICaptain())
	else:
		%IdentityComponent.SetOwner(CaptainManager.FindCaptainByName(captain_name))
		visible = true
		#ship_model.set_collision_layer_value(1, true)
		#ship_model.set_collision_layer_value(2, false)
		
		if GlobalVariables.camera_gimbal != null:
			GlobalVariables.camera_gimbal.SetTarget(self, false)
			GlobalVariables.camera_gimbal.InitScanner(resource.scanner.scanner_range, resource.scanner.zoom_max)		
	%ShipAIComponent.CheckIsAI(%IdentityComponent.object_owner.is_ai)
	
	for i in resource.turret_slots:
		if resource.mining_turret != null:
			var new_turret = mining_turret_scene.instantiate()
			new_turret.SetTurret(resource.mining_turret, i + 1, self, %TargetingComponent, %CargoComponent, %LaserSpawn)
			new_turret.name = "MiningTurret" + str(i + 1)
			%MiningContainer.add_child(new_turret)
			%MiningContainer.number_of_turrets = resource.turret_slots
			
		if resource.combat_turret != null:
			var new_turret = combat_turret_scene.instantiate()
			new_turret.SetTurret(resource.combat_turret, i + 1, self, %TargetingComponent, %LaserSpawn, %SalvagerComponent)
			new_turret.name = "CombatTurret" + str(i + 1)
			%CombatContainer.add_child(new_turret)
			%CombatContainer.number_of_turrets = resource.turret_slots
		
	damagable_components += resource.turret_slots
	
func GetOwner():
	return %IdentityComponent.object_owner
		
func GetCargo():
	return %CargoComponent.GetCargo()
	
func GetChassis():
	return %ChassisComponent.chassis_name
	
func IsCargoHoldEmpty():
	return %CargoComponent.IsCargoHoldEmpty()
	
func SubtractCargo(item : Resource, quantity : int):
	%CargoComponent.SubtractCargo(item, quantity)
	
func ClearCargo():
	%CargoComponent.ClearCargo()
	
func SetOwner(new_owner : Captain):
	%IdentityComponent.SetOwner(new_owner)
		
func TakeDamage(damage : int, accuracy : float, is_command : bool = false):
	if !is_command:
		print(str(accuracy) + ">" + str(rng.randf_range(0, 1)))
		if accuracy > rng.randf_range(0, 1):
			%ChassisComponent.DamageComponent(damage)
			print("chassis hit for " + str(damage) + " damage!")
			
			var new_text = shot_hit_text.instantiate()
			%ShotHit.add_child(new_text)
			new_text.text = "Shot hit for " + str(damage) + " damage!"
			new_text.label_settings.font_color = Color(1, 0.26, 0.31, 1)
			is_repaired = false
		else:
			var new_text = shot_hit_text.instantiate()
			%ShotHit.add_child(new_text)
			new_text.text = "Shot missed!"
			new_text.label_settings.font_color = Color(1, 1, 1, 1)
	else:
		%ChassisComponent.DamageComponent(damage)
		print("chassis hit for " + str(damage) + " damage!")
		is_repaired = false
		
func RepairShip(amount : int):
	%ChassisComponent.hp += amount
	if %ChassisComponent.hp >= %ChassisComponent.max_hp:
		%ChassisComponent.hp = %ChassisComponent.max_hp
		is_repaired = true
	print(%ChassisComponent.hp)
	
func DestroyShip():
	print_debug("ship destroyed")
	var wreck_instance = wreck.instantiate()
	GlobalVariables.main_scene.add_child(wreck_instance)
	print(wreck_instance)
	wreck_instance.position = self.position
	wreck_instance.rotation = self.rotation
	wreck_instance.wreck_size = %ChassisComponent.chassis_name
	wreck_instance.Initialize(%CargoComponent.PrepSalvageCargo())
	queue_free()

func _on_chassis_component_chassis_destroyed(_ship_node):
	DestroyShip()
