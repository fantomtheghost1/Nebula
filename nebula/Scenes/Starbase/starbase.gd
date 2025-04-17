extends Node3D

var crafting_component = preload("res://scenes/starbase/crafting_component.tscn")
var trading_component = preload("res://scenes/starbase/trade_component.tscn")
var repair_component = preload("res://scenes/starbase/repair_component.tscn")

var starbase_type : String = ""
var system_name : String = "Epsilon"
var hp : int = 0
var level : int = 0

@export var id : int = 0
@export var starbase_resource : Resource

func _ready():
	if starbase_resource != null and id != 0:
		Initialize(starbase_resource, id)

func Initialize(resource : Resource, starbase_id : int, system_name_param : String = "") -> void:
	id = starbase_id
	starbase_type = resource.starbase_type
	system_name = system_name_param
	hp = resource.hp
	level = resource.level
	var warehouse = %WarehouseComponent.CreateWarehouse()
	%IdentityComponent.SetOwner(CaptainManager.CreateAICaptain())
	
	%ShieldGenerator.SetShieldGenerator(resource.shield_generator)
	%GeneratorComponent.SetGenerator(resource.generator)
	%ScannerComponent.SetScanner(resource.scanner)
	%DockComponent.acceptable_chassis = resource.services["DOCKING"]
	
	if resource.services["CRAFTING"] == true:
		crafting_component = crafting_component.instantiate()
		%ServiceContainer.add_child(crafting_component)
		crafting_component.warehouse_component = %WarehouseComponent
		%CraftItem.visible = true
		crafting_component.starbase_level = level
		crafting_component.connect("BackPressed", _on_back_pressed)
		
	if resource.services["TRADE"] == true:
		trading_component = trading_component.instantiate()
		%ServiceContainer.add_child(trading_component)
		%Trade.visible = true
		trading_component.starbase_warehouse_container = %WarehouseComponent
		trading_component.connect("BackPressed", _on_back_pressed)
		
	if resource.services["REPAIR"] == true:
		repair_component = repair_component.instantiate()
		%ServiceContainer.add_child(repair_component)
		repair_component.Init(level)
		%DockComponent.has_repair_service = true
		
	for i in resource.turret_slots:
		print("created new turret")
		#var new_turret = mining_turret_scene.instantiate()
		#new_turret.SetTurret(ship_type.mining_turret, i + 1, self, %TargetingComponent, %CargoComponent, %LaserSpawn)
		#new_turret.name = "MiningTurret" + str(i + 1)
		#%MiningContainer.add_child(new_turret)
		
	#%MiningContainer.number_of_turrets = ship_type.turret_slots
	
	%WelcomeLabel.text = "Welcome to " + starbase_type + " " + system_name + "!"
	
func StartRepairs():
	repair_component.StartRepairs()
	
func StopRepairs():
	repair_component.StopRepairs()
	
func _on_back_pressed():
	%StarbaseUI.visible = true

func _on_deposit_materials_pressed() -> void:
	var warehouse = %WarehouseComponent.GetWarehouseFromCaptain(SteamManager.client)
	if !%DockComponent.docked_ships[0].IsCargoHoldEmpty():
		var new_cargo = %DockComponent.docked_ships[0].GetCargo()
		%DockComponent.docked_ships[0].ClearCargo()
		for item in new_cargo:
			warehouse.AddCargo(new_cargo[item].item, new_cargo[item].quantity)
	else:
		print("Cargo Hold is empty!")

func _on_craft_item_pressed() -> void:
	%StarbaseUI.visible = false
	crafting_component.CraftItemPressed()

func _on_trade_pressed() -> void:
	%StarbaseUI.visible = false
	trading_component.TradePressed()
