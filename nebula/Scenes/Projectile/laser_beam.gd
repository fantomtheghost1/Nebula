extends Node3D

func SetHeight(new_height : float):
	%BeamMesh.mesh.height = new_height
	%BeamMesh.position.z = -new_height / 2
	print(%BeamMesh.position.z)
	print(rotation)

func GetHeight():
	return %BeamMesh.mesh.height
