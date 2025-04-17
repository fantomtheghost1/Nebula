extends Node3D

# at some point, might need to fix an issue with wrecks not being detected when they are spawned in

@export var cargo_component : Node3D

var wrecks_in_radius : Array[Node3D]
var queued_wrecks_in_radius : Array[Node3D]
var salvaging : bool

func AddWreckInRadius(new_wreck : Node3D):
	if !salvaging:
		wrecks_in_radius.append(new_wreck)
	else:
		queued_wrecks_in_radius.append(new_wreck)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Salvage") and salvaging:
		print("salvage canceled...")
		salvaging = false
		%SalvageTimer.stop()
		for wreck in queued_wrecks_in_radius:
			wrecks_in_radius.append(wreck)
	elif event.is_action_pressed("Salvage") and wrecks_in_radius != [] and !salvaging:
		salvaging = true
		print("salvaging!")
		%SalvageTimer.wait_time = wrecks_in_radius[0].salvage_time
		%ShrinkTimer.wait_time = %SalvageTimer.wait_time / 5
		%ShrinkTimer.start()
		%SalvageTimer.start()
			
func _on_salvage_timer_timeout() -> void:
	cargo_component.AddCargoHold(wrecks_in_radius[0].wreck_loot)
	print("wreck salvaged!")
	print(wrecks_in_radius[0].wreck_loot)
	%ShrinkTimer.stop()
	wrecks_in_radius[0].queue_free()
	wrecks_in_radius.remove_at(0)
	
	if wrecks_in_radius == []:
		salvaging = false
		for wreck in queued_wrecks_in_radius:
			wrecks_in_radius.append(wreck)

func _on_shrink_timer_timeout() -> void:
	wrecks_in_radius[0].scale = wrecks_in_radius[0].scale * 0.7
