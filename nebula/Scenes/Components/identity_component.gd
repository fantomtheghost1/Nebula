#                      IDENTITY COMPONENT
################################################################
# This component manages the identity of the ship and starbase # 
################################################################

extends Node3D

# the faction the object belongs to
var faction : Faction

# the name of the object owner
var object_owner : String = "AI"

# determines whether the object is controlled by an npc
var is_npc : bool = true

# sets the object owner
func SetOwner(new_owner) -> void:
	object_owner = new_owner
	print("ship " + str(get_parent().id) + "'s owner changed: " + new_owner)
	
func SetFaction(new_faction : Faction) -> void:
	faction = new_faction
	
# determines whether the object belongs to the given faction
func IsMemberOfFaction(test_faction) -> bool:
	if faction == test_faction:
		return true
	return false
