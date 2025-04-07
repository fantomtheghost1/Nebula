extends Node3D

var recipe_button = preload("res://scenes/UI/recipe_button.tscn")
var selected_recipe = null
var recipe_being_crafted = null

var unloaded_recipes = [
	"res://resources/crafting_recipes/dummy_recipe_1.tres",
	"res://resources/crafting_recipes/dummy_recipe_2.tres"
]

var loaded_recipes = []

func _ready() -> void:
	for recipe in unloaded_recipes:
		var loaded_recipe = load(recipe)
		loaded_recipes.append(loaded_recipe)
		var new_button = recipe_button.instantiate()
		%RecipeButtonContainer.add_child(new_button)
		new_button.text = loaded_recipe.result
		new_button.pressed.connect(ShowRecipe.bind(new_button.text))
		
	print("recipes initialized")
	
func _process(delta: float) -> void:
	var cargo_hold = %CargoComponent.GetCargo()
	%MagnesiumAlloy.text = "Magnesium Alloy: \n" + str(cargo_hold[0])
	%CarbonFiber.text = "Carbon Fiber: \n" + str(cargo_hold[1])
	%TitaniumAlloy.text = "Titanium Alloy: \n" + str(cargo_hold[2])
	%ExoticMatter.text = "Exotic Matter: \n" + str(cargo_hold[3])
	%Graphene.text = "Graphene: \n" + str(cargo_hold[4])
	
func FindIndexByResult(result : String):
	for i in loaded_recipes.size():
		if loaded_recipes[i].result == result:
			return i
			
func ShowRecipe(result : String):
	var index = FindIndexByResult(result)
	selected_recipe = loaded_recipes[index]
	
	if !%RequiredMaterials.visible:
		%RequiredMaterials.visible = true
	
	%MagnesiumAlloyNeeded.text = "Magnesium Alloy: " + str(selected_recipe.magnesium_alloy_required)
	%CarbonFiberNeeded.text = "Carbon Fiber: " + str(selected_recipe.carbon_fiber_required)
	%TitaniumAlloyNeeded.text = "Titanium Alloy: " + str(selected_recipe.graphene_required)
	%ExoticMatterNeeded.text = "Exotic Matter: " + str(selected_recipe.exotic_matter_required)
	%GrapheneNeeded.text = "Graphene: " + str(selected_recipe.titanium_alloy_required)
	
func CanCraftRecipe(recipe):
	var cargo = %CargoComponent.GetCargo()
	if cargo[0] >= recipe.magnesium_alloy_required:
		if cargo[1] >= recipe.carbon_fiber_required:
			if cargo[2] >= recipe.graphene_required:
				if cargo[3] >= recipe.exotic_matter_required:
					if cargo[4] >= recipe.titanium_alloy_required:
						return true
	print("You do not have enough materials to craft this recipe...")
	return false

func _on_craft_item_pressed() -> void:
	%StarbaseMainMenu.visible = false
	%StarbaseCraftingMenu.visible = true
#		print(recipe.magnesium_alloy_required)
#		print(recipe.carbon_fiber_required)
#		print(recipe.graphene_required)
#		print(recipe.exotic_matter_required)
#		print(recipe.titanium_alloy_required)

func _on_back_pressed() -> void:
	%StarbaseMainMenu.visible = true
	%StarbaseCraftingMenu.visible = false
	%RequiredMaterials.visible = false

func _on_craft_pressed() -> void:
	if CanCraftRecipe(selected_recipe):
		recipe_being_crafted = selected_recipe
		%Craft.disabled = true
		%CraftingTime.wait_time = recipe_being_crafted.crafting_time
		%CraftingTime.start()

func _on_crafting_time_timeout() -> void:
	print(recipe_being_crafted.result + " has been crafted!")
	recipe_being_crafted = null
	%Craft.disabled = false
