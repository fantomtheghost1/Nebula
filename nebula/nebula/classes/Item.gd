#                              ITEM CLASS
###########################################################################
# This class represents resources and items stored in starbases and ships # 
###########################################################################

class_name Item

# represents the different items that exist in the game
enum ITEMS {METAL, SILICON, ISOTOPES, ICE, GOLD}

# maps the items to their descriptions
const ITEM_DESCRIPTIONS = {
	ITEMS.METAL : "is iron",
	ITEMS.SILICON : "is sisicatr3",
	ITEMS.ISOTOPES : "is topes",
	ITEMS.ICE : "i",
	ITEMS.GOLD : "strog"
}

# reverses the ITEMS enum and returns the enum string at the given index
# E.X.
# enum {WATER} is actually
# my_enum = {"WATER" : 0}
# reversed = {0 : "WATER"}
# allows us to say that:
# reversed[0] = "WATER"
static func GetItemFromIndex(index) -> String: # maybe write a helper function that will get any enum string from a given enum and index
	return HelperFunctions.GetEnumStringFromIndex(ITEMS, index)
