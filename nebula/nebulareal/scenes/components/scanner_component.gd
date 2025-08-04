extends Node3D


# Signals emitted when a target is detected or lost
signal TargetFound       # Emitted when a previously lost target re-enters the scanner
signal TargetLost        # Emitted when the current target leaves the scanner range


# Exported properties and references
@export var parent_node : Node3D          # Reference to the parent ship or starbase
@export var scanner_range : float          # Range of the scanner
@export var object_fade_in : float         # Duration for fade-in effect (currently commented out)
@export var IdentityComponent : Node3D    # Reference to the identity component


# Scanner state variables
var target : Node                         # Current target being tracked
var previous_target : Node                # Previously tracked target
var objects_in_range : Array              # Array of objects within scanner range


# Configures the scanner with properties from a resource
func SetScanner(resource : Resource):
	scanner_range = resource.scanner_range
	%Area3D.scale = Vector3(scanner_range, scanner_range, scanner_range)


# Handles objects entering the scanner's detection area
func _on_area_3d_body_entered(body):
	# Skip processing for starbases or if no valid owner exists
	if not HelperFunctions.CheckForObjectInGroup(parent_node, "starbases") and IdentityComponent.object_owner != null:
		# Only process for non-AI players and non-always-visible objects
		if not IdentityComponent.object_owner.is_ai and not HelperFunctions.CheckForObjectInGroup(body.get_parent(), "always_visible"):
			objects_in_range.append(body.get_parent())
			body.get_parent().visible = true
	
	# Add wrecks to the salvager component
	if HelperFunctions.CheckForObjectInGroup(body.get_parent(), "wrecks"):
		%SalvagerComponent.AddWreckInRadius(body.get_parent())
	
	# Emit signal if the entering body was the previous target
	if body.get_parent() == previous_target:
		TargetFound.emit()

# Handles objects exiting the scanner's detection area
func _on_area_3d_body_exited(body):
	# Skip processing for starbases or if no valid owner exists
	if not HelperFunctions.CheckForObjectInGroup(parent_node, "starbases") and IdentityComponent.object_owner != null:
		if not IdentityComponent.object_owner.is_ai:
			# Hide and remove non-always-visible objects from tracking
			if not HelperFunctions.CheckForObjectInGroup(body.get_parent(), "always_visible"):
				body.get_parent().visible = false
				objects_in_range.erase(body.get_parent())
	
	# Remove the object from the targetables group
	body.get_parent().remove_from_group("targetables")
	
	# Emit signal if the exiting body was the current target
	if body.get_parent() == target:
		TargetLost.emit()
