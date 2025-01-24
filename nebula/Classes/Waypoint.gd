class_name Waypoint

var position : Vector3 = Vector3.ZERO
var object = null
var visible = false

func _init(instance_position, instance_visible, instance_location):
	position = instance_position
	visible = instance_visible
	
	object = MeshInstance3D.new()
	object.position = instance_position
	object.mesh = SphereMesh.new()
	object.visible = visible
	instance_location.add_child(object)
	print_debug("waypoint created!")

func Destroy():
	object.queue_free()
