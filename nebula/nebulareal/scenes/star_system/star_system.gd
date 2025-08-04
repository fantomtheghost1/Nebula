class_name System
extends Node3D

# Exported variables for editor configuration
@export var ship_container: Node3D
@export var system_name: String
@export var id: int
@export var sun_color: Color

# System properties
var system_size: Dictionary = {}
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var system_owner: Node3D
var connections: Array[int] = []

# Initialize system with ID, connections, and optional owner
@rpc("authority", "call_local", "reliable")
func Initialize(id_param: int, new_position : Vector3, param_connections: Array[int] = [], system_owner_param: Node3D = null) -> void:
	id = id_param
	# Register system with SystemManager
	SystemManager.AddSystem(self)
	
	position = new_position
	
	# Generate and set system name
	system_name = HelperFunctions.GenerateName("system")
	var node_name: Array = system_name.split(" ")
	name = "".join(node_name)
	system_owner = system_owner_param
	connections = param_connections
	
	# Set random system size
	system_size = SystemManager.GetRandomSystemSize()
	
	# Generate asteroids
	GenerateAsteroids.rpc(rng.randi_range(system_size["ASTEROID_MIN"], system_size["ASTEROID_MAX"]))
	
	# Set sun properties
	sun_color = Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1), 1.0)
	%Sun.SetColor(sun_color)
	
	# Scale sun and floor
	var sun_scale: float = system_size["SUN_SCALE"]
	%Sun.scale = Vector3(sun_scale, sun_scale, sun_scale)
	%HyperlaneComponent.Initialize.rpc(500 * system_size["SYSTEM_SCALE_MULT"], connections)
	%Floor.scale = Vector3(system_size["SYSTEM_SCALE_MULT"], 1, system_size["SYSTEM_SCALE_MULT"])

# Initialize system with preset values
func InitializeWithPresetValues(
	id_param: int,
	system_name_param: String,
	system_size_param: Dictionary,
	system_sun_color: Color,
	param_connections: Array[int] = [],
	system_owner_param: Node3D = null
) -> void:
	id = id_param
	# Register system with SystemManager
	SystemManager.AddSystem(self)
	
	# Set system name and owner
	system_name = system_name_param
	var node_name: Array = system_name_param.split(" ")
	name = "".join(node_name)
	system_owner = system_owner_param
	connections = param_connections
	
	# Set system size and sun color
	system_size = system_size_param
	sun_color = system_sun_color
	%Sun.SetColor(sun_color)
	
	var sun_scale = system_size["SUN_SCALE"]
	%Sun.scale = Vector3(sun_scale, sun_scale, sun_scale)
	
	%HyperlaneComponent.Initialize.rpc(500 * system_size["SYSTEM_SCALE_MULT"], connections)
	%Floor.scale = Vector3(system_size["SYSTEM_SCALE_MULT"], 1, system_size["SYSTEM_SCALE_MULT"])

# Set system owner
func SetSystemOwner(system_owner_param: Node3D) -> void:
	system_owner = system_owner_param

# Generate asteroids with random properties
@rpc("authority", "call_local", "reliable")
func GenerateAsteroids(asteroid_count: int) -> void:
	var sizes: Array[String] = ["small", "medium", "large", "massive"]
	var compositions: Array[String] = ["magnesium_alloy", "carbon_fiber", "graphene", "exotic_matter", "titanium_alloy"]
	
	for i in range(asteroid_count):
		var placement_range: float = ((500 * system_size["SYSTEM_SCALE_MULT"]) / 2) - 50
		var size: String = sizes[rng.randi_range(0, 3)]
		var composition: String = compositions[rng.randi_range(0, 4)]
		
		# Create asteroid with random position, size, and composition
		AsteroidGenerator.CreateAsteroid(
			rng.randf_range(-placement_range, placement_range),
			rng.randf_range(-placement_range, placement_range),
			size,
			composition,
			name
		)

# Get all asteroids in the system
func GetAllAsteroids() -> Array:
	var asteroids: Array = []
	for asteroid in %AsteroidContainer.get_children():
		asteroids.append(asteroid)
	
	return asteroids

# Add starbase to system
func AddStarbase(starbase: Node3D) -> void:
	%StarbaseContainer.add_child(starbase)

# Get floor node
func GetFloor() -> Node3D:
	return %Floor
