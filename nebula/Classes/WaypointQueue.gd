class_name Queue

var Waypoint = preload("res://Classes/Waypoint.gd")

var first = 0
var last = -1
var queue = {}

func IsEmpty():
	return first > last

func Enqueue(waypoint : Waypoint):
	last = last + 1
	queue[last] = waypoint
	print("waypoint queued!")
	print(str(queue))

func Peek():
	if IsEmpty():
		return null
	return queue[first]

func Debug():
	return queue

func Dequeue():
	if IsEmpty():
		return null
	var value = queue[first]
	queue[first] = null
	first = first + 1
	return queue[first]

func ClearWaypoints():
	for wp in queue:
		if queue[wp] != null:
			queue[wp].Destroy()
		else:
			break
	queue = {}
	first = 0
	last = -1
	print("waypoint queue cleared!")
