extends Node3D

var waypoint_queue = preload("res://Classes/WaypointQueue.gd")

# determines the max speed of the ship
var max_speed = 0

# the current ship waypoint queue
var current_queue = waypoint_queue.new()

# holds the tween utilized by MoveShip()
var tween = null

# holds important node references
var ship_node : Node3D = null

# this function will override the current tween playing and change the current queue to the one provided
func SetCurrentQueue(new_queue):
	current_queue = new_queue
	MoveShip()

func MoveShip():
	
	# if you are currently tweening, end it
	if tween:
		tween.stop()
		
	# holds the next waypoint in the queue
	var current_waypoint = current_queue.Peek()
	
	# if the waypoint exists, create the tween 
	if current_waypoint:
		tween = get_tree().create_tween()
		tween.tween_property(ship_node, "position", current_waypoint.position, 2) \
			.set_trans(Tween.TRANS_SINE)
			#.set_ease(Tween.EASE_IN)
		tween.connect("finished", on_tween_finished)

# when the tween finishes, dequeue a waypoint and move to the next queued waypoint
func on_tween_finished():
	current_queue.Dequeue()
	MoveShip()
