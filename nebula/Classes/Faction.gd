#                                                FACTION CLASS
##################################################################################################################
# This class represents a faction and its relationships to other factions and the members that are a part of it. # 
##################################################################################################################

class_name Faction

# contains the name of the faction
var name : String 

# contains the username of the faction leader
var faction_leader = ""

# contains the usernames of the faction members
var members = []

# contains the faction objects of the faction's allies
var allies = []

# contains the faction objects of the faction's enemies
var enemies = []

func _init(faction_name, faction_owner) -> void:
	name = faction_name
	faction_leader = faction_owner
	members.append(faction_leader)
	print("New faction created! " + faction_name + " is owned by the player " + faction_leader + "!")
	
func AssignNewLeader(new_leader):
	faction_leader = new_leader

func AddAlly(new_ally):
	allies.append(new_ally)
	
func AddEnemy(new_enemy):
	enemies.append(new_enemy)
	
func AddMember(new_member):
	members.append(new_member)

func RemoveAlly(old_ally):
	allies.erase(old_ally)
	
func RemoveEnemy(old_enemy):
	enemies.erase(old_enemy)
	
func RemoveMember(old_member):
	members.erase(old_member)
