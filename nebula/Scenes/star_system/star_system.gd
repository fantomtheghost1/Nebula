extends Node3D

func Initialize(system : Resource):
	%Sun.mesh.material.albedo_color = system.sun_color
	%Sun.mesh.material.emission = system.sun_color
	%Sun.scale = system.sun_size
