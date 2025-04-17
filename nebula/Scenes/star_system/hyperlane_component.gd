extends Node3D

@export var connections : Array[Node3D]
@export var ship_container : Node3D

var relay_scene : PackedScene = preload("res://hyperlane_relay.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func Initialize(system_scale : int, connections_param : Array[Node3D] = []):
	var point = (system_scale / 2) - 50
	var relay_positions = [Vector3(point, 0, 0), Vector3(-point, 0, 0), Vector3(0, 0, point), Vector3(0, 0, -point)]
	connections = connections_param
	
	var index = 0
	for connection in connections:
		var new_relay = relay_scene.instantiate()
		new_relay.Initialize(connection)
		add_child(new_relay)
		new_relay.ship_container = ship_container
		new_relay.position = relay_positions[index]
		index += 1
		
