extends Node3D

signal ShipStartedMoving
signal ShipStoppedMoving

# determines the max speed of the ship
var max_speed = 0
var min_speed = 0
var acceleration = 0.0
var current_speed = 0

# holds the tween utilized by MoveShip()
var tween = null

var is_moving : bool = false

# holds important node references
var ship_node : Node3D = null

func IsMoving():
	return is_moving
	
func PathTo(target_pos : Vector3, number_of_waypoints : int, distance_between_waypoints: float, inaccuracy_coefficient: float):
	ShipStartedMoving.emit()
	
	var index = 0
	var previous_waypoint_pos = (target_pos * (index) / number_of_waypoints)
	for i in range(number_of_waypoints):
		index += 1

		var unaltered_waypoint_pos = (target_pos * (index) / number_of_waypoints)
		var current_waypoint_pos = Vector3(unaltered_waypoint_pos.x + distance_between_waypoints, 0, unaltered_waypoint_pos.z + distance_between_waypoints)
		var waypoint_distance = randf_range(1, inaccuracy_coefficient * 3)# * inaccuracy_coefficient
		
		if index != 1:
			current_waypoint_pos.x += waypoint_distance
			current_waypoint_pos.y += waypoint_distance

		current_waypoint_pos = Vector3(current_waypoint_pos.x, 0, current_waypoint_pos.z)
		
		%WaypointQueueHandler.QueueNewWaypoint(current_waypoint_pos)

func MoveShip():

	
	# if you are currently tweening, end it
	if tween:
		tween.stop()
		
	# holds the next waypoint in the queue
	var current_waypoint = %WaypointQueueHandler.queue_instance.Peek()
	
	# if the waypoint exists, create the tween 
	if current_waypoint:
		ShipStartedMoving.emit()
		tween = get_tree().create_tween()
		var tween_duration
		tween_duration = HelperFunctions.GetDistanceBetweenTwoPoints(ship_node.position, current_waypoint.position) / current_speed
		tween.tween_property(ship_node, "position", current_waypoint.position, tween_duration) \
			.set_trans(Tween.TRANS_LINEAR)
		tween.connect("finished", on_tween_finished)
	else: 
		current_speed = min_speed
		ShipStoppedMoving.emit()

# when the tween finishes, dequeue a waypoint and move to the next queued waypoint
func on_tween_finished():
	%WaypointQueueHandler.queue_instance.Dequeue()
	if (current_speed + acceleration) < max_speed:
		current_speed += acceleration
	else:
		current_speed = max_speed
	
	MoveShip()
