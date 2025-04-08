#                           CARGO COMPONENT
############################################################################
# This component replicates the behavior of a cargo hold in a ship or base # 
############################################################################

extends Node3D

# emited when the component is destroyed
signal CargoBayDestroyed(ship_node)

@export var identity_component : Node3D

# represented by a percentage, it signifies what percentage of cargo in the cargo hold will be present in ship salvage
@export var salvage_degradation_rate : float

# stores the cargo bay name the instance is currently using
var cargo_bay_name : String

# stores the cargo bay storage limit
var cargo_limit : int = 0

# literally just health
var hp : int = 1

# represents whether the component is destroyed or not
enum STATUS {ENABLED, DISABLED, DESTROYED}

var component_status = STATUS.ENABLED

# this represents the cargo bay and what it currently stores
var cargo_items = {
	Item.ITEMS.MAGNESIUM_ALLOY : 0, 
	Item.ITEMS.CARBON_FIBER : 0,
	Item.ITEMS.GRAPHENE : 0,
	Item.ITEMS.EXOTIC_MATTER : 0,
	Item.ITEMS.TITANIUM_ALLOY : 0
}

func _ready():
#	Console.create_command("get_player_cargo", self.GetCargo, "Shows the player cargo hold.")
	pass
# adds a given quantity of item to the current cargo hold
func AddCargo(item, quantity) -> void:
	if !IsCargoHoldFull():
		cargo_items[item] += quantity

# subtracts a given quantity of item from the current cargo hold
func SubtractCargo(item, quantity) -> void:
	if !IsCargoHoldFull():
		cargo_items[item] -= quantity
	
# replaces the current cargo hold with the one passed
func SetCargo(cargo_bay_dict : Dictionary) -> void:
	if !IsCargoHoldFull():
		cargo_items = cargo_bay_dict
		
func ClearCargo():
	cargo_items = {
		Item.ITEMS.MAGNESIUM_ALLOY : 0, 
		Item.ITEMS.CARBON_FIBER : 0,
		Item.ITEMS.GRAPHENE : 0,
		Item.ITEMS.EXOTIC_MATTER : 0,
		Item.ITEMS.TITANIUM_ALLOY : 0
	}
	
func IsCargoHoldEmpty() -> bool:
	var cargo_sum = 0
	
	# adds all the items in the cargo hold and ensures that none of the items are set to a negative number
	for item in cargo_items:
		if cargo_items[item] < 0:
			push_error("Cargo item is below zero. " + Item.GetItemFromIndex(item))
		else:
			cargo_sum += cargo_items[item]
			
	# ensures that the sum of all the items in the cargo hold do not exceed the cargo limit or has items less than zero
	if cargo_sum == 0:
		return true
	
	return false
	
# ensures that the cargo hold does not exceed the cargo limit or has items less than zero
func IsCargoHoldFull() -> bool:
	var cargo_sum = 0
	
	# adds all the items in the cargo hold and ensures that none of the items are set to a negative number
	for item in cargo_items:
		if cargo_items[item] < 0:
			push_error("Cargo item is below zero. " + Item.GetItemFromIndex(item))
		else:
			cargo_sum += cargo_items[item]
			
	# ensures that the sum of all the items in the cargo hold do not exceed the cargo limit or has items less than zero
	if cargo_sum < 0:
		push_error("Cargo is below zero. Current cargo sum: " + str(cargo_sum))
	elif cargo_sum > cargo_limit:
		push_error("Cargo is above the cargo limit. Current cargo sum: " + str(cargo_sum) + ". Max cargo: " + str(cargo_limit))
		return true
	elif cargo_sum == cargo_limit:
		print(str(cargo_sum) + " == " + str(cargo_limit))
		return true
		
	return false
	
# dudfshg
func GetCargo() -> Dictionary:
	return cargo_items
	
# sets the current cargo bay that the instance is using
func SetCargoBay(cargo_type : CargoType) -> void:
	cargo_bay_name = cargo_type.name
	cargo_limit = cargo_type.cargo_limit
	hp = cargo_type.max_hp
	
	if hp > 0:
		component_status = STATUS.ENABLED
	else:
		DestroyComponent()
		
	print_debug("cargo bay set!")
	
func PrepSalvageCargo():
	var salvage_cargo = {
		Item.ITEMS.MAGNESIUM_ALLOY : 0, 
		Item.ITEMS.CARBON_FIBER : 0,
		Item.ITEMS.GRAPHENE : 0,
		Item.ITEMS.EXOTIC_MATTER : 0,
		Item.ITEMS.TITANIUM_ALLOY : 0
	}
	
	for item in cargo_items:
		salvage_cargo[item] += (cargo_items[item] * salvage_degradation_rate)
	
	return salvage_cargo
	
func DamageComponent(damage) -> void:
	hp -= damage
	# if the component hp is depleted and the component hasn't been destroyed yet
	if hp <= 0 and component_status != STATUS.DESTROYED:
		DestroyComponent()

func DestroyComponent() -> void:
	component_status = STATUS.DESTROYED
	
	# generates a signal that passes the parent ship node as a parameter
	CargoBayDestroyed.emit(get_parent())
