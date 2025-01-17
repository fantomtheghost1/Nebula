#                          CARGO COMPONENT
############################################################################
# This component replicates the behavior of a cargo hold in a ship or base # 
############################################################################

extends Node3D

# imports the item class
var Item : Script = preload("res://Classes/Item.gd")

# emited when the component is destroyed
signal CargoBayDestroyed(ship_node)

# stores all of the defined types of cargo bays available in the game
# E.X. {"NAME" : {"CARGO_LIMIT" : INT, "HP" : INT}}
const CARGO_BAY_TYPES : Dictionary = {
	"DUMMY_MIN_CARGO_BAY" : {"CARGO_LIMIT" : 100, "HP" : 100},
	"DUMMY_MAX_CARGO_BAY" : {"CARGO_LIMIT" : 10000, "HP" : 10000},
	"DUMMY_ZERO":{"CARGO_LIMIT":0, "HP":0}
}

# stores the cargo bay type the instance is currently using
var cargo_bay_type : String = ""

# stores the cargo bay storage limit
var cargo_limit : int = 0

# literally just health
var hp : int = 1

# represents whether the component is destroyed or not
enum STATUS {ENABLED, DISABLED, DESTROYED}

var component_status = STATUS.ENABLED

# this represents the cargo bay and what it currently stores
var cargo = {
	Item.ITEMS.IRON_ORE : 0, 
	Item.ITEMS.SILICATE_ORE : 0,
	Item.ITEMS.ISOTOPES : 0,
	Item.ITEMS.ICE : 0,
	Item.ITEMS.TUNGSTEN_ORE : 0
}
	
# adds a given quantity of item to the current cargo hold
func AddCargo(item, quantity) -> void:
	cargo[item] += quantity
	AssertCargo()

# subtracts a given quantity of item from the current cargo hold
func SubtractCargo(item, quantity) -> void:
	cargo[item] -= quantity
	AssertCargo()
	
# replaces the current cargo hold with the one passed
func SetCargo(cargo_bay_dict : Dictionary) -> void:
	cargo = cargo_bay_dict
	AssertCargo()
	
# ensures that the cargo hold does not exceed the cargo limit or has items less than zero
func AssertCargo() -> void:
	# adds all the items in the cargo hold and ensures that none of the items are set to a negative number
	var cargo_sum = 0
	for item in cargo:
		if cargo[item] < 0:
			push_error("Cargo item is below zero. " + Item.GetItemFromIndex(item))
		else:
			cargo_sum += cargo[item]
		
	# ensures that the sum of all the items in the cargo hold do not exceed the cargo limit or has items less than zero
	if cargo_sum < 0:
		push_error("Cargo is below zero. Current cargo sum: " + str(cargo_sum))
	elif cargo_sum > CARGO_BAY_TYPES[cargo_bay_type]["CARGO_LIMIT"]:
		push_error("Cargo is above the cargo limit. Current cargo sum: " + str(cargo_sum) + ". Max cargo: " + str(CARGO_BAY_TYPES[cargo_bay_type]["CARGO_LIMIT"]))
	else:
		print("epic")
	
# dudfshg
func GetCargo() -> Dictionary:
	return cargo
	
# sets the current cargo bay that the instance is using
func SetCargoBay(cargo_bay : String) -> void:
	cargo_bay_type = cargo_bay
	cargo_limit = CARGO_BAY_TYPES[cargo_bay]["CARGO_LIMIT"]
	hp = CARGO_BAY_TYPES[cargo_bay]["HP"]
	print("cargo bay set!")
	
func DamageComponent(damage) -> void:
	hp -= damage
	# if the component hp is depleted and the component hasn't been destroyed yet
	if hp <= 0 and component_status != STATUS.DESTROYED:
		DestroyComponent()

func DestroyComponent() -> void:
	component_status = STATUS.DESTROYED
	
	# generates a signal that passes the parent ship node as a parameter
	CargoBayDestroyed.emit(get_parent())
