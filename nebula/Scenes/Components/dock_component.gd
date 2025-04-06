extends Node3D

@export var starbase : Node3D
var docked_ships = []
var queued_docking_ships = []

func AddQueuedDockingShip(ship_instance):
	queued_docking_ships.append(ship_instance)

func DockShip(ship_instance):
	docked_ships.append(ship_instance.ship_type)
	ship_instance.queue_free()
	GlobalVariables.camera_gimbal.SetTarget(starbase, true)

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
