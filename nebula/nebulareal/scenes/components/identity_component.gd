extends Node3D


# Reference to the captain node that owns this object
var object_owner : Node3D


# Exported properties for faction and ownership
@export var owner_id : int           # ID of the owning captain
@export var parent_node : Node3D     # Reference to the parent ship or starbase node


# Sets the owner of the object via RPC, updating faction and ownership details
@rpc("any_peer", "call_local", "reliable")
func SetOwner(new_owner_id : int) -> void:
	var new_owner = GlobalVariables.captain_container.FindCaptainByID(new_owner_id)
	if new_owner:
		object_owner = new_owner
		owner_id = new_owner.pid
		new_owner.current_piloted_object = parent_node
		print_rich("[color=light_blue][Identity] New owner ", new_owner_id, " assigned on peer ", multiplayer.multiplayer_peer.get_unique_id(), "![/color]")
		

# Returns the faction name of the object's owner
func GetFaction() -> String:
	return object_owner.faction_name if object_owner else ""


# Returns the captain node that owns this object
func GetOwner() -> Node3D:
	return object_owner
