extends Node3D

@export var ship_container : Node3D

var system_sizes = [
	{
		"SIZE" : "small",
		"SUN_SCALE" : 50,
		"SYSTEM_SCALE_MULT" : 1,
		"ASTEROID_MIN" : 25,
		"ASTEROID_MAX" : 50
	},
	{
		"SIZE" : "medium",
		"SUN_SCALE" : 75,
		"SYSTEM_SCALE_MULT" : 1.5,
		"ASTEROID_MIN" : 50,
		"ASTEROID_MAX" : 150
	},
	{
		"SIZE" : "large",
		"SUN_SCALE" : 150,
		"SYSTEM_SCALE_MULT" : 2,
		"ASTEROID_MIN" : 100,
		"ASTEROID_MAX" : 250
	},
	{
		"SIZE" : "massive",
		"SUN_SCALE" : 250,
		"SYSTEM_SCALE_MULT" : 3,
		"ASTEROID_MIN" : 150,
		"ASTEROID_MAX" : 300
	}
]

var system_size = {}

var asteroid_gen = preload("res://generators/asteroid_generator.gd").new()

var rng = RandomNumberGenerator.new()

var system_owner : Faction
var connections : Array[Node3D]
var system_name : String
var id : int

func Initialize(id_param : int, connections : Array[Node3D] = [], system_owner_param : Faction = null):
	id = id_param
	
	system_name = HelperFunctions.GenerateName("system")
	var node_name = system_name.split(" ")
	name = "".join(node_name)
	system_owner = system_owner_param
	
	system_size = system_sizes[rng.randi_range(0, 3)]
	
	if system_owner != null:
		print_debug(system_owner.name + " now owns the system " + system_name + "!")
	GenerateAsteroids(rng.randi_range(system_size["ASTEROID_MIN"], system_size["ASTEROID_MAX"]))
	
	var color = Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1), 255)
	%Sun.SetColor(color)
	
	var scale = system_size["SUN_SCALE"]
	%Sun.scale = Vector3(scale, scale, scale)
	%HyperlaneComponent.Initialize(500 * system_size["SYSTEM_SCALE_MULT"], connections) 
	
	%Floor.scale = Vector3(system_size["SYSTEM_SCALE_MULT"], 1, system_size["SYSTEM_SCALE_MULT"])
	
func SetSystemOwner(system_owner_param):
	system_owner = system_owner_param
	print_debug(system_owner.name + " now owns the system " + system_name + "!")
	
func GenerateAsteroids(asteroid_count : int):
	var asteroid_resources = ResourceDb.GetAsteroids()
	var sizes : Array[String] = ["small", "medium", "large", "massive"]
	var compositions : Array[String] = ["magnesium_alloy", "carbon_fiber", "graphene", "exotic_matter", "titanium_alloy"]
	
	for i in range(asteroid_count):
		var placement_range = ((500 * system_size["SYSTEM_SCALE_MULT"]) / 2) - 50
		var asteroid = asteroid_gen.CreateAsteroid(rng.randf_range(-placement_range, placement_range), rng.randf_range(-placement_range, placement_range), sizes[rng.randi_range(0, 3)], compositions[rng.randi_range(0, 4)])
		%AsteroidContainer.add_child(asteroid)
		
func AddStarbase(starbase : Node3D):
	%StarbaseContainer.add_child(starbase)
	
func GetFloor():
	return %Floor
#func _on_system_area_body_entered(body: Node3D) -> void:
#	%Floor.ToggleFloor()
