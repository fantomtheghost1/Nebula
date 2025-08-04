extends MeshInstance3D

func SetColor(color : Color):
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = 12
	material_override = material

func SetAlbedo(color : Color):
	mesh.material.albedo_color = color
	
func SetEmissionColor(color : Color):
	mesh.material.emission = color
