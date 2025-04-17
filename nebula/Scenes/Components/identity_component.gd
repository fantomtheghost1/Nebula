#                      IDENTITY COMPONENT
################################################################
# This component manages the identity of the ship and starbase # 
################################################################

extends Node3D

# the name of the object owner
var object_owner : Captain

@export var parent_node : Node3D

# sets the object owner
func SetOwner(new_owner : Captain) -> void:
	object_owner = new_owner
	new_owner.ChangeCurrentPilotedShip(parent_node.id)
	print("ship " + str(get_parent().id) + "'s owner changed: " + new_owner.name)
	
func GetOwner() -> Captain:
	return object_owner
