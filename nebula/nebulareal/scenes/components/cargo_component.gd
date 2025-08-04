extends Node3D


# Signal emitted when the cargo bay is destroyed, passing the parent ship node
signal CargoBayDestroyed(ship_node)


# Reference to the identity component of the ship or base
@export var identity_component : Node3D

# Percentage of cargo retained in salvage (0.0 to 1.0)
@export var salvage_degradation_rate : float

# Dictionary storing cargo bay contents for salvage
@export var salvage_cargo_bay : Dictionary


# Name of the current cargo bay
var cargo_bay_name : String

# Current slot index in the cargo bay
var current_cargo_slot : int = 0

# Maximum number of cargo slots available
var max_cargo_slots : int = 0

# Health points of the cargo bay component
var hp : int = 1

# Enum defining the component's operational status
enum STATUS {ENABLED, DISABLED, DESTROYED}
var component_status = STATUS.ENABLED

# Dictionary storing current cargo bay contents
var cargo_bay : Dictionary


# Initializes the cargo bay with properties from a resource
func Initialize(resource : Resource) -> void:
	cargo_bay_name = resource.name
	max_cargo_slots = resource.max_cargo_slots
	hp = resource.max_hp
	
	if hp > 0:
		component_status = STATUS.ENABLED
	else:
		DestroyComponent()
	
	print_rich("[color=orange][CargoBay] Initialized: ", cargo_bay_name, "[/color]")


# Adds a specified quantity of an item to the cargo bay
func AddCargo(item : Resource, quantity : int) -> void:
	if not IsCargoHoldFull():
		var index = GetAvailableSlotByID(item.id)
		if index != -1 and (cargo_bay[index].quantity + quantity <= cargo_bay[index].item.stack_limit):
			cargo_bay[index].quantity += quantity
		elif index != -1:
			var remaining = quantity - (cargo_bay[index].item.stack_limit - cargo_bay[index].quantity)
			cargo_bay[index].quantity = cargo_bay[index].item.stack_limit
			
			while remaining > 0:
				if remaining <= cargo_bay[index].item.stack_limit:
					cargo_bay[current_cargo_slot] = {"item": item, "quantity": remaining}
					remaining = 0
					current_cargo_slot += 1
				else:
					cargo_bay[current_cargo_slot] = {"item": item, "quantity": cargo_bay[index].item.stack_limit}
					remaining -= cargo_bay[index].item.stack_limit
					current_cargo_slot += 1
		else:
			cargo_bay[current_cargo_slot] = {"item": item, "quantity": quantity}
			current_cargo_slot += 1


# Adds items from another cargo hold to this one
func AddCargoHold(new_cargo_hold : Dictionary):
	for item in new_cargo_hold:
		AddCargo(new_cargo_hold[item].item, new_cargo_hold[item].quantity)


# Removes a specified quantity of an item from the cargo bay
func SubtractCargo(item : Resource, quantity) -> void:
	var slot = GetAnySlotByID(item.id)
	if not IsCargoHoldFull() and cargo_bay[slot] != null:
		if cargo_bay[slot].quantity - quantity > 0:
			cargo_bay[slot].quantity -= quantity
		else:
			while quantity > 0:
				quantity -= cargo_bay[slot].quantity
				if quantity > 0:
					cargo_bay[slot] = cargo_bay[current_cargo_slot - 1]
					cargo_bay.erase(current_cargo_slot - 1)
					current_cargo_slot -= 1


# Replaces the current cargo bay with a new one
func SetCargo(cargo_bay_dict : Dictionary) -> void:
	if not IsCargoHoldFull():
		cargo_bay = cargo_bay_dict


# Clears all items from the cargo bay
func ClearCargo():
	cargo_bay = {}
	current_cargo_slot = 0


# Prepares cargo for salvage when the ship is destroyed
func PrepSalvageCargo():
	var items = ResourceDb.GetItems()
	var dummy_ship_recipe = {
		0: {"item": items[1], "quantity": 30},
		1: {"item": items[0], "quantity": 30}
	}
	AddCargoHold(dummy_ship_recipe)
	salvage_cargo_bay = cargo_bay.duplicate()
	
	for item in salvage_cargo_bay:
		salvage_cargo_bay[item].item = salvage_cargo_bay[item].item.id
		salvage_cargo_bay[item].quantity = (cargo_bay[item].quantity * salvage_degradation_rate)
	
	return salvage_cargo_bay


# Checks if the cargo bay is empty
func IsCargoHoldEmpty() -> bool:
	var cargo_sum = 0
	for item in cargo_bay:
		cargo_sum += cargo_bay[item].quantity
	
	return cargo_sum == 0


# Checks if the cargo bay is full
func IsCargoHoldFull() -> bool:
	var cargo_slots_used = cargo_bay.size()
	return cargo_slots_used >= max_cargo_slots


# Returns the current cargo bay contents
func GetCargo() -> Dictionary:
	return cargo_bay


# Finds a slot containing an item with the specified ID
func GetAnySlotByID(item_id : int):
	for item in cargo_bay:
		if cargo_bay[item].item.id == item_id:
			return item
	return -1


# Finds a slot with an item that has room for more
func GetAvailableSlotByID(item_id : int):
	for item in cargo_bay:
		if cargo_bay[item].item.id == item_id and cargo_bay[item].quantity < 64:
			return item
	return -1


# Returns the total quantity of an item by ID
func GetQuantityFromID(item_id : int):
	var total = 0
	for item in cargo_bay:
		if cargo_bay[item].item.id == item_id:
			total += cargo_bay[item].quantity
	return total


# Applies damage to the cargo bay component
func DamageComponent(damage) -> void:
	hp -= damage
	if hp <= 0 and component_status != STATUS.DESTROYED:
		DestroyComponent()


# Marks the component as destroyed and emits the destruction signal
func DestroyComponent() -> void:
	component_status = STATUS.DESTROYED
	CargoBayDestroyed.emit(get_parent())
