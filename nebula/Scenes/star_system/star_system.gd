extends Node3D

@export var ship_container : Node3D
var connections : Array[Node3D]
var system_name : String
var id : int

func Initialize(system : Resource, id_param : int, connections : Array[Node3D] = []):
	id = id_param
	system_name = system.system_name
	name = "StarSystem" + str(id)
	
	%Sun.mesh.material.albedo_color = system.sun_color
	%Sun.mesh.material.emission = system.sun_color
	%Sun.scale = system.sun_size
	%HyperlaneComponent.Initialize(connections) 
	
func GetFloor():
	return %Floor
#func _on_system_area_body_entered(body: Node3D) -> void:
#	%Floor.ToggleFloor()
