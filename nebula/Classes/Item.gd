#                          ITEM CLASS
###########################################################################
# This class represents resources and items stored in starbases and ships # 
###########################################################################

class_name Item

# represents the different items that exist in the game
enum ITEMS {IRON_ORE, SILICATE_ORE, ISOTOPES, ICE, TUNGSTEN_ORE}

# maps the items to their descriptions
const ITEM_DESCRIPTIONS = {
	ITEMS.IRON_ORE : "is iron",
	ITEMS.SILICATE_ORE : "is sisicatr3",
	ITEMS.ISOTOPES : "is topes",
	ITEMS.ICE : "i",
	ITEMS.TUNGSTEN_ORE : "strog"
}

# reverses the ITEMS enum and returns the enum string at the given index
# E.X.
# enum {WATER} is actually
# my_enum = {"WATER" : 0}
# reversed = {0 : "WATER"}
# allows us to say that:
# reversed[0] = "WATER"
static func GetItemFromIndex(index) -> String:
	var reversed = {}
	for key in ITEMS:
		reversed[ITEMS[key]] = key
	return reversed[index]
