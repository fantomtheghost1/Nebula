class_name WaypointQueue

var queue = []

func IsEmpty():
	if len(queue) > 0:
		return false
	return true

func Enqueue(waypoint : Waypoint):
	queue.push_back(waypoint)

func Peek():
	if IsEmpty():
		return null
	return queue[0]

func Debug():
	return queue

func Dequeue():
	if IsEmpty():
		return null
	queue[0].Destroy()
	queue.pop_front()

func ClearWaypoints():
	for wp in queue:
		if wp != null:
			wp.Destroy()
		else:
			break
	queue = []
