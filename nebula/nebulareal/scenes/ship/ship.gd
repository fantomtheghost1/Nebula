class_name Ship
extends Node3D

# Preload scenes for wreck, turrets, and UI text
var wreck = preload("res://scenes/wreck/wreck.tscn")
var combat_turret_scene = preload("res://scenes/components/combat_turret.tscn")
var mining_turret_scene = preload("res://scenes/components/mining_turret.tscn")

# Define ship properties
var object_type : String = "ship"
var docked : bool = false
var can_dock : bool = false
var is_repaired : bool = true
var dock_in_radius : Node3D

# Exported variables for editor configuration
@export var damage_handler : Node3D
@export var identity_comp : Node3D
@export var cargo_comp : Node3D
@export var chassis_comp : Node3D
@export var ship_model : CharacterBody3D
@export var resource : Resource
@export var id : int = 0

# Initialize ship with type, ID, and AI status
@rpc("authority", "call_local", "reliable")
func Initialize(ship_type : String, ship_id : int, is_ai : bool = false) -> void:
	id = ship_id
	
	# Set initial position
	position = Vector3(150, 0, 150)
	
	if ship_id != multiplayer.multiplayer_peer.get_unique_id():
		return
	
	# Load ship resource from database
	resource = ResourceDb.GetShipByName(ship_type)
	
	# Instantiate and scale ship model if available
	if resource.model != null:
		var model = resource.model.instantiate()
		model.scale = Vector3(30, 30, 30)
		get_node("ShipModel").add_child(model)
		%MeshInstance3D.queue_free()
		
	# Configure ship components
	%ShieldGenerator.SetShieldGenerator(resource.shield_generator)
	%CargoComponent.Initialize(resource.cargo_bay)
	%GeneratorComponent.SetGenerator(resource.generator)
	%ChassisComponent.SetChassisType(resource.chassis)
	%EngineComponent.SetEngine(resource.engine)
	%ScannerComponent.SetScanner(resource.scanner)
		
	# Set ship owner
	%IdentityComponent.SetOwner.rpc(ship_id)
	
	%TurretUI.Init()
	
	# Create turrets based on available slots
	for i in resource.turret_slots:
		if resource.mining_turret != null:
			CreateMiningTurret(i)
		if resource.combat_turret != null:
			CreateCombatTurret(i)
			
	if id == multiplayer.multiplayer_peer.get_unique_id():
		if resource.mining_turret != null:
			%MiningContainer.Init()
		if resource.combat_turret != null:
			%CombatContainer.Init()
			
	# Configure AI or player-specific settings
	if is_ai:
		GlobalVariables.captain_container.CreateCaptain.rpc(true)
		#var captain = GlobalVariables.captain_container.FindCaptainByID(id)
		#%IdentityComponent.object_owner = captain.captain_name
	else:
		GlobalVariables.client_captain = GlobalVariables.captain_container.FindCaptainByID(id)
		visible = true
		GlobalVariables.camera_gimbal.InitScanner(resource.scanner.scanner_range, resource.scanner.zoom_max)
		if GlobalVariables.camera_gimbal != null:
			GlobalVariables.camera_gimbal.SetTarget(self, false)
	
# Set docked state and visibility
@rpc("any_peer", "call_local", "reliable")
func SetDocked(is_docked : bool):
	if is_docked:
		docked = true
		visible = false
	else:
		docked = false
		visible = true
	
# Create and configure a combat turret
func CreateCombatTurret(index : int):
	var new_turret = combat_turret_scene.instantiate()
	new_turret.SetTurret(
		resource.combat_turret.max_hp, 
		resource.combat_turret.damage, 
		resource.combat_turret.accuracy, 
		resource.combat_turret.fire_rate,
		resource.combat_turret.beam_color
	)
	
	# Set turret properties and references
	new_turret.id = index
	new_turret.name = "CombatTurret" + str(new_turret.id)
	new_turret.targeting_component = %TargetingComponent
	new_turret.salvager_component = %SalvagerComponent
	new_turret.ship_node = self
	
	# Add turret to combat container
	%CombatContainer.add_child(new_turret)
	%CombatContainer.number_of_turrets = resource.turret_slots
	
# Create and configure a mining turret
func CreateMiningTurret(index: int):
	var new_turret = mining_turret_scene.instantiate()
	new_turret.SetTurret(
		resource.mining_turret.max_hp,
		resource.mining_turret.damage,
		resource.mining_turret.mining_laser_rate,
		resource.mining_turret.beam_color
	)
	
	# Set turret properties and references
	new_turret.id = index + 1
	new_turret.targeting_component = %TargetingComponent
	new_turret.ship_node = self
	new_turret.cargo_component = %CargoComponent
	new_turret.laser_spawn = %LaserSpawn
	
	# Add turret to mining container
	%MiningContainer.add_child(new_turret, true)
	%MiningContainer.number_of_turrets = resource.turret_slots
	%MiningContainer.turret_tier = resource.mining_turret.turret_tier
	
# Set ship name
@rpc("authority", "call_local", "reliable")
func SetName(ship_name : String):
	name = ship_name
		
# Repair ship chassis
func RepairShip(amount : int):
	%ChassisComponent.hp += amount
	if %ChassisComponent.hp >= %ChassisComponent.max_hp:
		%ChassisComponent.hp = %ChassisComponent.max_hp
		is_repaired = true
	
# Destroy ship and spawn wreck
@rpc("any_peer", "call_local")
func DestroyShip():
	if multiplayer.get_unique_id() != id:
		return
	var wreck_instance = wreck.instantiate()
	GlobalVariables.main_scene.add_child(wreck_instance)
	wreck_instance.position = self.position
	wreck_instance.rotation = self.rotation
	wreck_instance.wreck_size = %ChassisComponent.chassis_name
	wreck_instance.Initialize(%CargoComponent.PrepSalvageCargo())
	queue_free()
		
# Handle chassis destruction event
func _on_chassis_component_chassis_destroyed(_ship_node):
	DestroyShip.rpc_id(id)

func RemoveShip():
	set_multiplayer_authority(-1)
	queue_free()
