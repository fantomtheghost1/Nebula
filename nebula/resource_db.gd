extends Node

var unloaded_asteroids = [
	"res://resources/asteroid/small/small_titanium_alloy.tres",
	"res://resources/asteroid/small/small_magnesium_alloy.tres",
	"res://resources/asteroid/small/small_graphene.tres",
	"res://resources/asteroid/small/small_exotic_matter.tres",
	"res://resources/asteroid/small/small_carbon_fiber.tres",
	"res://resources/asteroid/medium/medium_carbon_fiber.tres",
	"res://resources/asteroid/medium/medium_exotic_matter.tres",
	"res://resources/asteroid/medium/medium_graphene.tres",
	"res://resources/asteroid/medium/medium_magnesium_alloy.tres",
	"res://resources/asteroid/medium/medium_titanium_alloy.tres",
	"res://resources/asteroid/large/large_carbon_fiber.tres",
	"res://resources/asteroid/large/large_exotic_matter.tres",
	"res://resources/asteroid/large/large_graphene.tres",
	"res://resources/asteroid/large/large_magnesium_alloy.tres",
	"res://resources/asteroid/large/large_titanium_alloy.tres",
	"res://resources/asteroid/massive/massive_carbon_fiber.tres",
	"res://resources/asteroid/massive/massive_exotic_matter.tres",
	"res://resources/asteroid/massive/massive_graphene.tres",
	"res://resources/asteroid/massive/massive_magnesium_alloy.tres",
	"res://resources/asteroid/massive/massive_titanium_alloy.tres"
]

var unloaded_ships = [
	"res://resources/ships/portum_navis_industriam/laboris.tres",
	"res://resources/ships/dummy_max_combat.tres",
	"res://resources/ships/dummy_max_mining.tres",
	"res://resources/ships/dummy_min_combat.tres",
	"res://resources/ships/dummy_min_mining.tres",
	"res://resources/ships/dummy_zero.tres"
]

var unloaded_recipes = [
	"res://resources/crafting_recipes/dummy_recipe_1.tres",
	"res://resources/crafting_recipes/dummy_recipe_2.tres"
]

var unloaded_items = [
	"res://resources/items/carbon_fiber.tres", 
	"res://resources/items/exotic_matter.tres", 
	"res://resources/items/graphene.tres",
	"res://resources/items/magnesium_alloy.tres",
	"res://resources/items/titanium_alloy.tres"
]

var unloaded_systems = [
	"res://resources/systems/dummy_yellow.tres"
]

var loaded_asteroids = []
var loaded_ships = []
var loaded_recipes = []
var loaded_items = []
var loaded_systems = []

func _ready() -> void:
	for asteroid in unloaded_asteroids:
		loaded_asteroids.append(load(asteroid))
		
	for ship in unloaded_ships:
		loaded_ships.append(load(ship))
	
	for item in unloaded_items:
		loaded_items.append(load(item))
		
	for recipe in unloaded_recipes:
		loaded_recipes.append(load(recipe))
		
	for system in unloaded_systems:
		loaded_systems.append(load(system))

func GetAsteroidByProperties(size : String, composition: String):
	var index = 0
	for asteroid in unloaded_asteroids:
		if asteroid == "res://resources/asteroid/" + size + "/" + size + "_" + composition + ".tres":
			return loaded_asteroids[index]
		index += 1
		
func GetShipByName(ship_name : String):
	var index = 0
	for ship in unloaded_ships:
		if ship.find(ship_name) != -1:
			return loaded_ships[index]
		index += 1
		
func GetSystemByName(system_name : String):
	var index = 0
	for system in unloaded_systems:
		if system.find(system_name) != -1:
			return loaded_systems[index]
		index += 1
			
func GetItems():
	return loaded_items
	
func GetRecipes():
	return loaded_recipes
