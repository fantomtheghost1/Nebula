extends Node3D

@export var starbase : Node3D
@export var starbase_ui : Control
var docked_ships = []
var queued_docking_ships = []
var ship_gen = preload("res://generators/ship_generator.gd").new()

func AddQueuedDockingShip(ship_instance):
	queued_docking_ships.append(ship_instance)

func DockShip(ship_instance):
	#change to a dictionary when multiplayer is added and stuff
	docked_ships.append(ship_instance)
	ship_instance.visible = false
	GlobalVariables.camera_gimbal.SetTarget(starbase, true)
	starbase_ui.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(%StarbaseUI, "modulate:a", 1, GlobalVariables.generic_tween_time) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	
# for the T1
func FindDockedShipWithID(id : int):
	pass

func _on_body_entered(body: Node3D) -> void:
	var object = body.get_parent()
	
	for ship in queued_docking_ships:
		if object == ship:#GameManager.IsObjectShip(object):
			DockShip(object)
			queued_docking_ships.erase(object)

func _on_body_exited(body: Node3D) -> void:
	var object = body.get_parent()
	if GameManager.IsObjectShip(object):
		object.can_dock = false
		object.dock_in_radius = null

func _on_starbase_click_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("Interact"):
		print("test")

func _on_button_pressed() -> void:
	docked_ships[0].visible = true
	GlobalVariables.camera_gimbal.SetTarget(docked_ships[0], false)
	starbase_ui.visible = false
	docked_ships.erase(docked_ships[0])
	#for ship in docked_ships:
	#	if ship.get_node("IdentityComponent").owner == SteamManager.client.name:
	#		ship_gen.CreateShipWithResource(starbase.position.x, starbase.position.z, docked_ships[0], false)
