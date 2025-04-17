#                                                CAPTAIN CLASS
##################################################################################################################
# This class represents a player and its relationships to other factions and the members that are a part of it. # 
##################################################################################################################

class_name Captain

var id : int

var name : String

var is_ai : bool

# contains the faction the player is a member of
var faction : Faction

# contains the amount of credits the player has at their disposal
var _credits : int = 0

var current_piloted_ship_id : int = -1

var ship_inventory : Array[Resource] = []

func _init(init_name : String, is_captain_ai : bool = true) -> void:
	name = init_name
	is_ai = is_captain_ai
	
func AddNewShip(ship_resource : Resource):
	ship_inventory.append(ship_resource)
	
func RemoveShip(ship_resource : Resource):
	ship_inventory.erase(ship_resource)
	
func ChangeCurrentPilotedShip(new_ship_id : int):
	current_piloted_ship_id = new_ship_id
	
func SetPlayerFaction(new_faction : Faction):
	faction = new_faction
	
func AddCredits(amount : int):
	_credits += amount

func SubtractCredits(amount : int):
	_credits -= amount
	
func SetCredits(amount : int):
	_credits = amount

func GetCredits():
	return _credits
