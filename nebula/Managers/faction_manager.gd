extends Node

var factions = []

func CreateFaction(faction_name : String, faction_color : Color, faction_leader : Captain) -> Faction:
	var new_faction = Faction.new(faction_name, faction_color, faction_leader)
	factions.append(new_faction)
	ClearMemberFromOtherFactions(new_faction, faction_leader)
	return new_faction
	
func CreateFactionCommand(faction_name : String) -> void:
	var rng = RandomNumberGenerator.new()
	var color = Color(rng.randf_range(0, 1), rng.randf_range(0, 1), rng.randf_range(0, 1))
	var new_faction = Faction.new(faction_name, color, SteamManager.client)
	factions.append(new_faction)
	ClearMemberFromOtherFactions(new_faction, SteamManager.client)
			
func ClearMemberFromOtherFactions(new_faction : Faction, old_member : Captain):
	for faction in factions:
		if faction.faction_leader == old_member and faction != new_faction:
			print("clearing old faction")
			faction.RemoveMember(old_member)
			if faction.members == []:
				factions.erase(faction)
			else:
				var new_leader = CaptainManager.FindAvailableAIFactionLeader()
				faction.faction_leader = new_leader
				faction.AddMember(new_leader)
	
func AddFaction(new_faction : Faction) -> void:
	factions.append(new_faction)
	ClearMemberFromOtherFactions(new_faction, new_faction.faction_leader)
	for faction in factions:
		new_faction.AddFactionToDiplomacy(faction)
		
	for faction in factions:
		if faction != new_faction:
			faction.AddFactionToDiplomacy(new_faction)
			
func AddMemberToFaction(faction_name : String, new_member : Captain):
	var faction = FindFactionByName(faction_name)
	ClearMemberFromOtherFactions(faction, new_member)
	faction.AddMember(new_member)
	
func KickMemberFromFaction(faction_name : String, old_member : Captain):
	var faction = FindFactionByName(faction_name)
	faction.RemoveMember(old_member)
	old_member.faction = null
	
func AllyWithFaction(faction_one_name : String, faction_two_name : String):
	var faction_one = FindFactionByName(faction_one_name)
	var faction_two = FindFactionByName(faction_two_name)
	
	faction_one.DeclareAlly(faction_two)
	faction_two.DeclareAlly(faction_one)
	
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
	
func GetFactionsCommand():
	var final_string = ""
	for faction in factions:
		final_string += faction.name + "\n"
		
	return final_string	
	
func JoinFactionCommand(faction_name : String, captain_id : int):
	var captain = CaptainManager.FindCaptainByID(captain_id)
	AddMemberToFaction(faction_name, captain)
	
func KickFactionCommand(faction_name : String, captain_id : int):
	var captain = CaptainManager.FindCaptainByID(captain_id)
	KickMemberFromFaction(faction_name, captain)
	
func GetFactionMembersCommand(faction_name : String):
	var faction = FindFactionByName(faction_name)
	var final_string = ""
	print(faction.members)
	for member in faction.members:
		print(member)
		final_string += member.name
		if faction.faction_leader == member:
			final_string += " : faction leader"
		final_string += "\n"
		
	return final_string	
