extends Node3D

var id : int
var warehouse_owner : Captain
var max_warehouse_slots : int
var current_available_slot : int = 0
var salvage_degradation_rate : float

var warehouse_cargo : Dictionary

###########################################
# --------------- SETTERS --------------- #
###########################################

func AddCargo(item : Resource, quantity : int) -> void:
	if !IsWarehouseFull():
		var index = GetAvailableSlotByID(item.id)
		if index != -1 and (warehouse_cargo[index].quantity + quantity <= warehouse_cargo[index].item.stack_limit):
			warehouse_cargo[index].quantity += quantity
		elif index != -1:
			var cargo = quantity
			cargo -= (warehouse_cargo[index].item.stack_limit - warehouse_cargo[index].quantity)
			warehouse_cargo[index].quantity = warehouse_cargo[index].item.stack_limit
			
			while cargo > 0:
				print(cargo)
				if cargo <= warehouse_cargo[index].item.stack_limit:
					warehouse_cargo[current_available_slot] = {
						"item": item,
						"quantity": cargo
					}
					cargo = 0
					current_available_slot += 1
				else:
					warehouse_cargo[current_available_slot] = {
						"item": item,
						"quantity": warehouse_cargo[index].item.stack_limit
					}
					cargo -= warehouse_cargo[index].item.stack_limit
					current_available_slot += 1
			
		else:
			warehouse_cargo[current_available_slot] = {
				"item": item,
				"quantity": quantity
			}
			current_available_slot += 1
		print(warehouse_cargo)
		
# subtracts a given quantity of item from the current cargo hold
func SubtractCargo(item : Resource, quantity) -> void:
	var slot = GetAnySlotByID(item.id)
	if !IsWarehouseEmpty() and warehouse_cargo[slot] != null:
		if warehouse_cargo[slot].quantity - quantity > 0:
			warehouse_cargo[slot].quantity -= quantity
		elif warehouse_cargo[slot].quantity - quantity == 0:
			warehouse_cargo[slot] = warehouse_cargo[current_available_slot - 1]
			warehouse_cargo.erase(current_available_slot - 1)
			current_available_slot -= 1
		else:
			print("looping")
			while quantity > 0:
				if !IsWarehouseEmpty():
					var cargo_quant = warehouse_cargo[slot].quantity
					warehouse_cargo[slot].quantity -= quantity
					quantity = quantity - cargo_quant
					print_debug(quantity)
					if quantity >= 0:
						warehouse_cargo[slot] = warehouse_cargo[current_available_slot - 1]
						warehouse_cargo.erase(current_available_slot - 1)
						current_available_slot -= 1
						slot = GetAnySlotByID(item.id)
						if slot == -1:
							print("item is depleted, breaking")
							return
				else:
					print("The cargo hold is empty")
					return
	
# replaces the current cargo hold with the one passed
func SetCargo(cargo_bay_dict : Dictionary) -> void:
	if !IsWarehouseFull():
		warehouse_cargo = cargo_bay_dict
			
# when the ship is destroyed, prepares the ship's cargo to be placed into a ship wreck
func PrepSalvageCargo():
	var salvage_cargo_bay = warehouse_cargo
	
	# for each item in the cargo bay, degrade the amount of items by the given rate
	for item in warehouse_cargo:
		salvage_cargo_bay[item].quantity = (warehouse_cargo[item].quantity * salvage_degradation_rate)
	
	return salvage_cargo_bay
			
###########################################
# --------------- GETTERS --------------- #
###########################################
			
func GetWarehouseCargo() -> Dictionary:
	return warehouse_cargo
	
func GetAnySlotByID(item_id : int):
	for item in warehouse_cargo:
		if warehouse_cargo[item].item.id == item_id:
			return item
			
	return -1
			
func GetAvailableSlotByID(item_id : int):
	for item in warehouse_cargo:
		if warehouse_cargo[item].item.id == item_id and warehouse_cargo[item].quantity < 64:
			return item
			
	return -1
	
func GetQuantityFromID(item_id : int):
	var total = 0
	for item in warehouse_cargo:
		if warehouse_cargo[item].item.id == item_id:
			total += warehouse_cargo[item].quantity
			print(total)
			
	return total
	
func GetDifferentItemsInWarehouse():
	var items = []
	for item in warehouse_cargo:
		if !(warehouse_cargo[item].item in items):
			print_debug(warehouse_cargo[item].quantity)
			items.append(warehouse_cargo[item].item)
	return items
			
# returns true if warehouse is full
func IsWarehouseFull() -> bool:
	var cargo_slots_used = 0
	
	# adds all the items in the warehouse
	for item in warehouse_cargo:
		cargo_slots_used += 1
			
	if cargo_slots_used == max_warehouse_slots:
		print(str(cargo_slots_used) + " == " + str(max_warehouse_slots))
		return true
		
	return false

func IsWarehouseEmpty() -> bool:
	# adds all the items in the warehouse
	for item in warehouse_cargo:
		return false
		
	return true
