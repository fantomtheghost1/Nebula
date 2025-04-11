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

var current_cargo_slot : int

# stores the max cargo bay inventory slot
var max_cargo_slots : int = 0

# literally just health
var hp : int = 1

# represents whether the component is destroyed or not
enum STATUS {ENABLED, DISABLED, DESTROYED}

var component_status = STATUS.ENABLED

var cargo_bay : Dictionary

# sets the current cargo bay that the instance is using
func Initialize(cargo_type : CargoType) -> void:
	cargo_bay_name = cargo_type.name
	max_cargo_slots = cargo_type.max_cargo_slots
	hp = cargo_type.max_hp
	
	if hp > 0:
		component_status = STATUS.ENABLED
	else:
		DestroyComponent()
		
	print_debug("cargo bay set!")

###########################################
# --------------- SETTERS --------------- #
###########################################

# adds a given quantity of item to the current cargo hold
func AddCargo(item : Resource, quantity : int) -> void:
	if !IsCargoHoldFull():
		var index = GetAvailableSlotByID(item.id)
		if index != -1 and (cargo_bay[index].quantity + quantity <= cargo_bay[index].item.stack_limit):
			cargo_bay[index].quantity += quantity
		elif index != -1:
			var cargo = quantity
			cargo -= (cargo_bay[index].item.stack_limit - cargo_bay[index].quantity)
			cargo_bay[index].quantity = cargo_bay[index].item.stack_limit
			
			while cargo > 0:
				print(cargo)
				if cargo <= cargo_bay[index].item.stack_limit:
					cargo_bay[current_cargo_slot] = {
						"item": item,
						"quantity": cargo
					}
					cargo = 0
					current_cargo_slot += 1
				else:
					cargo_bay[current_cargo_slot] = {
						"item": item,
						"quantity": cargo_bay[index].item.stack_limit
					}
					cargo -= cargo_bay[index].item.stack_limit
					current_cargo_slot += 1
			
		else:
			cargo_bay[current_cargo_slot] = {
				"item": item,
				"quantity": quantity
			}
			current_cargo_slot += 1
		
# adds a cargo bay to the current cargo bay
func AddCargoHold(new_cargo_hold : Dictionary):
	for item in new_cargo_hold:
		AddCargo(new_cargo_hold[item].item, new_cargo_hold[item].quantity)
		
# subtracts a given quantity of item from the current cargo hold
func SubtractCargo(item : Resource, quantity) -> void:
	if !IsCargoHoldFull() and cargo_bay[current_cargo_slot] != null:
		if cargo_bay[current_cargo_slot].quantity - quantity < 0:
			cargo_bay[current_cargo_slot].quantity -= quantity
		else:
			cargo_bay[current_cargo_slot].quantity = 0
			cargo_bay[current_cargo_slot] = null
			current_cargo_slot -= 1
	
# replaces the current cargo hold with the one passed
func SetCargo(cargo_bay_dict : Dictionary) -> void:
	if !IsCargoHoldFull():
		cargo_bay = cargo_bay_dict
		
# clears the object's cargo bay
func ClearCargo():
	cargo_bay = {}
	
# when the ship is destroyed, prepares the ship's cargo to be placed into a ship wreck
func PrepSalvageCargo():
	var salvage_cargo_bay = cargo_bay
	
	# for each item in the cargo bay, degrade the amount of items by the given rate
	for item in cargo_bay:
		salvage_cargo_bay[item].quantity = (cargo_bay[item].quantity * salvage_degradation_rate)
	
	return salvage_cargo_bay
	
###########################################
# --------------- GETTERS --------------- #
###########################################
	
# returns true if the cargo bay is empty
func IsCargoHoldEmpty() -> bool:
	var cargo_sum = 0
	
	# adds all the items in the cargo hold
	for item in cargo_bay:
		cargo_sum += cargo_bay[item].quantity
			
	if cargo_sum == 0:
		return true
	
	return false
	
# returns true if cargo bay is full
func IsCargoHoldFull() -> bool:
	var cargo_slots_used = 0
	
	# adds all the items in the cargo hold
	for item in cargo_bay:
		cargo_slots_used += 1
			
	if cargo_slots_used == max_cargo_slots:
		print(str(cargo_slots_used) + " == " + str(max_cargo_slots))
		return true
		
	return false
	
# dudfshg
func GetCargo() -> Dictionary:
	return cargo_bay
	
func GetAvailableSlotByID(item_id : int):
	for item in cargo_bay:
		if cargo_bay[item].item.id == item_id and cargo_bay[item].quantity < 64:
			return item
			
	return -1
	
func GetQuantityFromID(item_id : int):
	var total = 0
	for item in cargo_bay:
		if cargo_bay[item].item.id == item_id:
			total += cargo_bay[item].quantity
			
	return total
	
func DamageComponent(damage) -> void:
	hp -= damage
	# if the component hp is depleted and the component hasn't been destroyed yet
	if hp <= 0 and component_status != STATUS.DESTROYED:
		DestroyComponent()

func DestroyComponent() -> void:
	component_status = STATUS.DESTROYED
	
	# generates a signal that passes the parent ship node as a parameter
	CargoBayDestroyed.emit(get_parent())
