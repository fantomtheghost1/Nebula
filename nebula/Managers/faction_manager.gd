extends Node

var factions = []

func CreateFaction(faction_name : String) -> void:
	factions.append(Faction.new(faction_name, SteamManager.GetSteamUsername()))
	
func GetFactionMembers(faction_name : String):
	return FindFactionByName(faction_name).members

func FindFactionByName(faction_name : String) -> Faction:
	for faction in factions:
		if faction.name == faction_name:
			return faction
	return null
	
func GetFactionFromPlayer(player_name : String) -> Faction:
	for faction in factions:
		for player in faction.players:
			if player == player_name:
				return faction
				
	return null
	
func GetFactionMembersCommand(faction_name : String):
	var faction = FindFactionByName(faction_name)
	var final_string = ""
	print(faction.members)
	for member in faction.members:
		print(member)
		final_string += member
		if faction.faction_leader == member:
			final_string += " : faction leader"
		final_string += "\n"
		
	return final_string	
