extends Node3D

@export var connections : Array[int]
@export var ship_container : Node3D

var relay_scene : PackedScene = preload("res://scenes/star_system/hyperlane_relay.tscn")

@rpc("call_local", "any_peer", "reliable")
func Initialize(system_scale : int, connections_param : Array[int] = []):
	var point = roundi((float(system_scale) / 2.0) - 50.0)
	var relay_positions = [Vector3(point, 0, 0), Vector3(-point, 0, 0), Vector3(0, 0, point), Vector3(0, 0, -point)]
	connections = connections_param
	
	for connection in connections:
		var new_relay = relay_scene.instantiate()
		new_relay.Initialize(connection)
		add_child(new_relay, true)
		new_relay.position = relay_positions.pick_random()
		
