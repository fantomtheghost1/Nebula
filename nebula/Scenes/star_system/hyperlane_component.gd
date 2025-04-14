extends Node3D

@export var connections : Array[Node3D]
@export var ship_container : Node3D

var relay_scene : PackedScene = preload("res://hyperlane_relay.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func Initialize(connections_param : Array[Node3D] = []):
	connections = connections_param
	
	for connection in connections:
		var new_relay = relay_scene.instantiate()
		new_relay.Initialize(connection)
		add_child(new_relay)
		new_relay.ship_container = ship_container
		new_relay.position = Vector3(randf_range(-200, 200), 0, randf_range(-200, 200))
