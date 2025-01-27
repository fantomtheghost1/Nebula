extends Node3D

signal ShipStartedMoving(ship_node)
signal ShipStoppedMoving(ship_node)

# determines the max speed of the ship
var max_speed = 0

# holds the tween utilized by MoveShip()
var tween = null

var is_moving : bool = false

# holds important node references
var ship_node : Node3D = null

func IsMoving():
	return is_moving
	
#func PathTo(target_pos : Vector3, number_of_waypoints : int, minimum_waypoint_distance : float, maximum_waypoint_distance : float, maximum_angle_error: float):
#	var distance_between_ship_and_target : float = HelperFunctions.GetDistanceBetweenTwoPoints(ship_node.position, target_pos)
#	for i in range(number_of_waypoints):
#		var waypoint = Waypoint.new()
	
func MoveShip():
	
	# if you are currently tweening, end it
	if tween:
		tween.stop()
		
	# holds the next waypoint in the queue
	var current_waypoint = %WaypointQueueHandler.queue_instance.Peek()
	
	# if the waypoint exists, create the tween 
	if current_waypoint:
		tween = get_tree().create_tween()
		var tween_duration = HelperFunctions.GetDistanceBetweenTwoPoints(ship_node.position, current_waypoint.position) / max_speed
		tween.tween_property(ship_node, "position", current_waypoint.position, tween_duration) \
			.set_trans(Tween.TRANS_SINE)
			#.set_ease(Tween.EASE_IN)
		tween.connect("finished", on_tween_finished)

# when the tween finishes, dequeue a waypoint and move to the next queued waypoint
func on_tween_finished():
	%WaypointQueueHandler.queue_instance.Dequeue()
	MoveShip()
