#                                                FACTION CLASS
##################################################################################################################
# This class represents a faction and its relationships to other factions and the members that are a part of it. # 
##################################################################################################################

class_name Faction

# contains the name of the faction
var name : String 

# contains the captain object of the faction leader
var faction_leader : Captain

var faction_color : Color

# contains the usernames of the faction members
var members = []

# contains the faction objects of the faction's allies
var allies = []

# contains the faction objects of the faction's hostiles
var hostiles = []

var diplomacy_instance = {
	"CAN_BUY" : true,
	"CAN_SELL" : true,
	"CAN_REPAIR" : true
}

var diplomacy = {}

func _init(faction_name, faction_color_param, faction_owner) -> void:
	name = faction_name
	faction_leader = faction_owner
	faction_color = faction_color_param
	faction_leader.faction = self
	
	members.append(faction_leader)
	print("New faction created! " + faction_name + " is owned by the player " + faction_leader.name + "!")
	
func AssignNewLeader(new_leader):
	faction_leader = new_leader
	new_leader.faction = self
	
func AddFactionToDiplomacy(faction : Faction):
	diplomacy[faction] = diplomacy_instance
	
func UpdateDiplomacy(faction : Faction, new_diplomacy : Dictionary):
	diplomacy[faction] = new_diplomacy
	
func DeclareAlly(new_ally):
	allies.append(new_ally)
	
func RevokeAlly(old_ally):
	allies.erase(old_ally)
	
func DeclareWar(new_enemy):
	hostiles.append(new_enemy)
	
func RevokeWar(old_enemy):
	hostiles.erase(old_enemy)
	
func AddMember(new_member):
	if members == []:
		faction_leader = new_member
	members.append(new_member)
	new_member.faction = self
	
func RemoveMember(old_member):
	members.erase(old_member)
