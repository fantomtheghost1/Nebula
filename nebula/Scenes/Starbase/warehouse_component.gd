extends Node3D

@export var max_warehouse_slots : int
@export var salvage_degradation_rate : float

var next_warehouse_id : int = 0
var warehouse_scene : PackedScene = preload("res://scenes/starbase/warehouse.tscn")

func CreateWarehouse(warehouse_owner : Captain = null):
	var warehouse = warehouse_scene.instantiate()
	add_child(warehouse)
	
	warehouse.id = next_warehouse_id
	
	if warehouse.id != 0:
		print_debug(warehouse_owner)
		warehouse.warehouse_owner = warehouse_owner
		
	warehouse.max_warehouse_slots = max_warehouse_slots
	warehouse.salvage_degradation_rate = salvage_degradation_rate

	next_warehouse_id += 1
	return warehouse
	#print("warehouse created for " + warehouse.warehouse_owner.name)
	
func GetWarehouseFromCaptain(captain : Captain):
	for warehouse in get_children():
		if captain == warehouse.warehouse_owner:
			print("warehouse found!")
			return warehouse
	return null

func GetWarehouseFromID(warehouse_id : int):
	for warehouse in get_children():
		if warehouse_id == warehouse.id:
			print("warehouse found!")
			return warehouse
	return null
