extends Node3D

var waypoint_queue = preload("res://classes/WaypointQueue.gd")

@export var waypoints_visible = false

##var bt_player : BTPlayer
#var blackboard : Blackboard

# the current ship waypoint queue
var queue_instance

func _ready():
	# initialize a new waypoint queue
	queue_instance = WaypointQueue.new()
	#blackboard = bt_player.blackboard
	#blackboard.bind_var_to_property("queue_instance", self, "queue_instance")

func QueueNewWaypoint(waypoint_pos):
	var waypoint = Waypoint.new(waypoint_pos, waypoints_visible, GlobalVariables.main_scene)
	queue_instance.Enqueue(waypoint)
