extends Node3D

# Publicly configurable beam height
@export var height : float

# Publicly configurable beam color
@export var color : Color

# Sets the height of the beam and repositions it accordingly (network-safe)
@rpc("any_peer", "call_local")
func SetHeight(new_height : float) -> void:
	height = new_height
	%BeamMesh.mesh.height = height
	%BeamMesh.position.z = -height / 2  # Center the mesh vertically based on new height

# Returns the current height of the beam mesh
func GetHeight() -> float:
	return %BeamMesh.mesh.height

# Sets the beam's color via emission and logs the change (network-safe)
@rpc("any_peer", "call_local")
func SetColor(new_color : Color) -> void:
	color = new_color
	%BeamMesh.mesh.material.emission = color
