extends Control

@export var inventory_slot : PackedScene

var ui_slots : Array[Control]
var slot_x : int = 10
var slot_y : int = 10

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenInventory"):
		visible = !visible

func UpdateUI(cargo_hold : Dictionary):
	
	#for item in cargo_hold
	var new_slot = inventory_slot.instantiate()
	%InventoryContainer.add_child(new_slot)
	new_slot.position = Vector2(slot_x, slot_y)
	#new_slot.text = item + "\n" + str(quantity)
	ui_slots.append(new_slot)
	
	if ui_slots.size() % 10 == 0:
		slot_y += 70
		slot_x = 10
	else:
		slot_x += 70
