# Defines the Asteroid class, representing an asteroid entity in the game
# Extends Node3D to position the asteroid in a 3D scene
class_name Asteroid
extends Node3D

# Type identifier for the object, set to "asteroid" by default
@export var object_type : String = "asteroid"
# Resource defining the asteroid's material composition
@export var composition : Resource
# Maximum ore capacity of the asteroid
@export var ore_max : int
# Current ore amount remaining in the asteroid
@export var ore : int
# Unique identifier for the asteroid, defaults to 0
@export var id : int = 0
# Resource containing asteroid properties (e.g., model, scale)
@export var resource : Resource
# Rate at which the asteroid rotates (radians per second)
var rotation_rate : float
# Random number generator for initializing rotation rate
var rng = RandomNumberGenerator.new()
# Reference to the global camera for raycasting
var camera = GlobalVariables.camera

# Tracks whether the player is hovering over the asteroid
var hovering : bool = false

# Initializes the asteroid with a given ID and resource
# Parameters:
# - param_id: Unique ID for the asteroid
# - asteroid_resource: Resource containing asteroid properties
func Initialize(param_id : int, asteroid_resource : Resource) -> void: 
	# Assign the provided resource to the asteroid
	resource = asteroid_resource
	# Set the asteroid's ID
	id = param_id
	# Set the composition from the resource
	composition = resource.composition
	# Initialize current ore to the resource's ore value
	ore = resource.ore
	# Set maximum ore to the initial ore value
	ore_max = ore
	# Generate a random rotation rate between 0.008 and 0.6 radians per second
	rotation_rate = rng.randf_range(0.008, 0.6)
	
	# Set the server as the authority for this asteroid
	set_multiplayer_authority(1)  # Server (peer ID 1) has authority
	
	# If the resource includes a model, instantiate and add it to the ModelContainer
	if resource.model != null:
		var model = resource.model.instantiate()
		%ModelContainer.add_child(model)
		
	# Scale the asteroid uniformly based on the resource's scale value
	scale = scale * Vector3(resource.scale, resource.scale, resource.scale)

# Applies damage to the asteroid and calculates ore yield
# Parameters:
# - damage: Amount of damage (ore) to remove
# Returns: Dictionary with ore yield and composition
func TakeDamage(damage : int):
	var ore_yield = 0
	UpdateAsteroidState.rpc(damage)
	
	# If ore is depleted, calculate yield and destroy the asteroid
	if ore <= 0:
		ore_yield = ore + damage
	else:
		ore_yield = damage
		
	# Return a dictionary with the ore yield and composition
	return {
		"ore_yield": ore_yield,
		"composition": composition
	}
	
# This rpc updates all clients about important properties
@rpc("call_local", "any_peer", "reliable")
func UpdateAsteroidState(damage):
	
	# Reduce the current ore by the damage amount
	ore -= damage
	
	# if ore is greater than 0, slightly reduce the asteroid's scale
	if ore > 0:
		scale = scale * (0.95)
	else:
		if is_multiplayer_authority():
			AsteroidManager.RemoveAsteroid(id)
			queue_free()

# Updates the asteroid's state each frame
# Parameters:
# - delta: Time elapsed since the last frame
func _process(delta: float) -> void:
	# Check if the player is hovering over the asteroid
	IsPlayerHovering()
	# Rotate the asteroid around the Y-axis based on rotation rate and delta time
	rotation = Vector3(rotation.x, rotation.y + rotation_rate * delta, rotation.z)
	# If hovering, update the tooltip's position to follow the mouse
	if hovering:
		# Position the tooltip relative to the mouse position with an offset
		%TooltipLabel.position = get_viewport().get_mouse_position() + Vector2(-131, 25)

# Checks if the player is hovering over the asteroid with the mouse
func IsPlayerHovering():
	# Get the current mouse position in the viewport
	var mouse_pos = get_viewport().get_mouse_position()
	# Access the 3D world's physics space for raycasting
	var space = get_world_3d().direct_space_state
	# Create a new physics ray query for collision detection
	var ray_query = PhysicsRayQueryParameters3D.new()
	
	# Exit if no camera is available
	if !camera:
		return

	# Set the ray's origin to the camera's projected position at the mouse
	ray_query.from = camera.project_ray_origin(mouse_pos)
	
	# Set the ray's endpoint far in the direction of the mouse's ray
	ray_query.to = ray_query.from + camera.project_ray_normal(mouse_pos) * 10000000
	
	# Perform the raycast to detect collisions
	var result = space.intersect_ray(ray_query)
	
	# If no collision is detected, hide the tooltip and reset hovering state
	if result == { }:
		if hovering == true:
			%TooltipLabel.visible = false
			hovering = false
		return
		
	# Check the groups of the collided object's parent
	for group in result["collider"].get_parent().get_groups():
		# If colliding with a click floor and hovering, hide the tooltip
		if group == "click_floors" and hovering:
			%TooltipLabel.visible = false
			hovering = false
		
		# If colliding with an asteroid, it's this asteroid, and it's visible, show the tooltip
		if group == "asteroids" and result["collider"].get_parent() == self and !hovering and visible:
			hovering = true
			%TooltipLabel.visible = true
			# Set the tooltip text to display the asteroid's size and composition
			%TooltipLabel.text = "%s %s Asteroid" % [HelperFunctions.GetAsteroidSizeFromScale(resource.scale).capitalize(), composition.name]
			return
