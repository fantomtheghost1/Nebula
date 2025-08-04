extends Node3D


# Reference to the cargo component for storing salvaged items
@export var cargo_component : Node3D


# Arrays to manage wrecks within salvaging radius
var wrecks_in_radius : Array[Node3D]      # Wrecks currently available for salvaging
var queued_wrecks_in_radius : Array[Node3D]  # Wrecks queued while salvaging is active
var salvaging : bool = false              # Flag indicating if salvaging is in progress


# Adds a wreck to the appropriate array based on salvaging state
func AddWreckInRadius(new_wreck : Node3D):
	if not salvaging:
		wrecks_in_radius.append(new_wreck)
	else:
		queued_wrecks_in_radius.append(new_wreck)


# Handles input events for starting or canceling salvage operations
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Salvage") and salvaging:
		print_rich("[color=orange][Salvager] Salvage canceled...[/color]")
		salvaging = false
		%SalvageTimer.stop()
		for wreck in queued_wrecks_in_radius:
			wrecks_in_radius.append(wreck)
		queued_wrecks_in_radius.clear()
	elif event.is_action_pressed("Salvage") and not wrecks_in_radius.is_empty() and not salvaging:
		salvaging = true
		print_rich("[color=orange][Salvager] Starting salvage![/color]")
		%SalvageTimer.wait_time = wrecks_in_radius[0].salvage_time
		%ShrinkTimer.wait_time = %SalvageTimer.wait_time / 5
		%ShrinkTimer.start()
		%SalvageTimer.start()


# Processes the salvage operation when the salvage timer expires
func _on_salvage_timer_timeout() -> void:
	var wreck_loot = wrecks_in_radius[0].wreck_loot
	print_rich("[color=orange][Salvager] Wreck salvaged![/color]")
	for item in wreck_loot:
		var item_resource = ResourceDb.GetItemByID(wreck_loot[item].item)
		wreck_loot[item].item = item_resource
	cargo_component.AddCargoHold(wreck_loot)
	
	%ShrinkTimer.stop()
	wrecks_in_radius[0].queue_free()
	wrecks_in_radius.remove_at(0)
	
	if wrecks_in_radius.is_empty():
		salvaging = false
		for wreck in queued_wrecks_in_radius:
			wrecks_in_radius.append(wreck)
		queued_wrecks_in_radius.clear()


# Gradually shrinks the wreck being salvaged
func _on_shrink_timer_timeout() -> void:
	wrecks_in_radius[0].scale *= 0.7
