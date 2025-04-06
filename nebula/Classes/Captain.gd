#                                                CAPTAIN CLASS
##################################################################################################################
# This class represents a player and its relationships to other factions and the members that are a part of it. # 
##################################################################################################################

class_name Captain

var name : String

# contains the faction the player is a member of
var faction : Faction

# contains the amount of credits the player has at their disposal
var credits : int = 0

func _init(init_name : String) -> void:
	name = init_name
	
func SetPlayerFaction(new_faction : Faction):
	faction = new_faction
	
func AddCredits(amount : int):
	credits += amount
