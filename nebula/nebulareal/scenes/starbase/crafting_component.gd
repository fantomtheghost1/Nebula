extends Node3D

signal BackPressed

var warehouse_component = null
var starbase_level : int = 0

var material_needed = preload("res://scenes/UI/material_needed.tscn")
#var recipe_button = preload("res://scenes/UI/recipe_button.tscn")
var selected_recipe = null
var recipe_being_crafted = null
var amount_being_crafted : int = 1

var loaded_recipes = []
var loaded_items = []

func _ready() -> void:
	
	for recipe in ResourceDb.GetRecipes():
		loaded_recipes.append(recipe)
	for item in ResourceDb.GetItems():
		loaded_items.append(item)
	
	for recipe in loaded_recipes:
		if recipe.minimum_starbase_level <= starbase_level:
			var new_button = Button.new()
			%RecipeButtonContainer.add_child(new_button)
			new_button.text = recipe.result.name
			new_button.pressed.connect(ShowRecipe.bind(new_button.text))
		
	print_rich("[color=yellow]Recipes Initialized!")

func FindItemWithID(id : int):
	for item in loaded_items:
		if item.id == id:
			return item
	
func FindIndexByResult(result : String):
	for i in loaded_recipes.size():
		if loaded_recipes[i].result.name == result:
			return i
			
func ShowRecipe(result : String):
	
	for label in %MaterialsContainer.get_children():
		label.queue_free()
	
	var label_y = 35
	var index = FindIndexByResult(result)
	selected_recipe = loaded_recipes[index]
	
	if !%RequiredMaterials.visible:
		%RequiredMaterials.visible = true
		
	for item in selected_recipe.recipe:
		var new_label = material_needed.instantiate()
		%MaterialsContainer.add_child(new_label)
		new_label.position = Vector2(-168, label_y)
		new_label.text = item["ITEM"].name + ": " + str(item["QUANTITY"] * amount_being_crafted)
		label_y += 15
	
	#%MagnesiumAlloyNeeded.text = "Magnesium Alloy: " + str(selected_recipe.magnesium_alloy_required)
	#%CarbonFiberNeeded.text = "Carbon Fiber: " + str(selected_recipe.carbon_fiber_required)
	#%TitaniumAlloyNeeded.text = "Titanium Alloy: " + str(selected_recipe.graphene_required)
	#%ExoticMatterNeeded.text = "Exotic Matter: " + str(selected_recipe.exotic_matter_required)
	#%GrapheneNeeded.text = "Graphene: " + str(selected_recipe.titanium_alloy_required)
	
func CanCraftRecipe(recipe):
	for item in recipe.recipe:
		var warehouse = warehouse_component.GetWarehouseFromCaptain(GlobalVariables.client_captain)
		pass
		if warehouse.GetQuantityFromID(item["ITEM"].id) < (item["QUANTITY"] * amount_being_crafted):
			print_rich("[color=yellow]You Do Not Have Enough Materials To Craft This Recipe...")
			return false
	print_rich("[color=orange]Crafting...")
	return true

func CraftItemPressed() -> void:
	%CraftingUI.visible = true

func _on_back_pressed() -> void:
	BackPressed.emit()
	%CraftingUI.visible = false
	%RequiredMaterials.visible = false

func _on_craft_pressed() -> void:
	if CanCraftRecipe(selected_recipe):
		var warehouse = warehouse_component.GetWarehouseFromCaptain(GlobalVariables.client_captain)
		recipe_being_crafted = selected_recipe
		
		for item in selected_recipe.recipe:
			warehouse.SubtractCargo(item["ITEM"], (item["QUANTITY"] * amount_being_crafted))
		
		%Craft.disabled = true
		%CraftingTime.wait_time = (recipe_being_crafted.crafting_time * amount_being_crafted)
		%CraftingTime.start()

func _on_crafting_time_timeout() -> void:
	var warehouse = warehouse_component.GetWarehouseFromCaptain(GlobalVariables.client_captain)
	print_rich("[color=orange]%s has been crafted![/color]" % recipe_being_crafted.result.name)
	warehouse.AddCargo(recipe_being_crafted.result, amount_being_crafted)
	recipe_being_crafted = null
	%Craft.disabled = false

func _on_quantity_slider_value_changed(value: float) -> void:
	%QuantityManual.placeholder_text = str(roundi(value)) + "x"
	amount_being_crafted = roundi(value)

func _on_quantity_manual_text_changed(new_text: String) -> void:
	%QuantitySlider.value = float(new_text)
	amount_being_crafted = roundi(float(new_text))
