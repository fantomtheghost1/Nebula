extends Node3D

@export var warp_pos : Vector3
@export var ship_container_path : String

func Initialize(connection_id):
	var connection = SystemManager.GetSystemByID(connection_id)
	RelayManager.AddRelay(self)
	warp_pos = Vector3(connection.position.x - 150, 0 , connection.position.z - 150)
	ship_container_path = connection.ship_container.get_path()

@rpc("any_peer", "call_local", "reliable")
func Warp(subject_path : String):
	var subject = get_node(subject_path)
	subject.position = warp_pos
	subject.call_deferred("reparent", get_node(ship_container_path))
