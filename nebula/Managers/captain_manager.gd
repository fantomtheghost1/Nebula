extends Node

var captains : Array[Captain]
var next_captain_id = 0

func CreateAICaptain():
	var new_captain = Captain.new("AI Captain " + str(next_captain_id))
	AddCaptain(new_captain)
	return new_captain

func AddCaptain(captain : Captain):
	captains.append(captain)
	captain.id = next_captain_id
	next_captain_id += 1

func FindCaptainByName(captain_name : String):
	for captain in captains:
		if captain.name == captain_name:
			return captain
			
func FindCaptainByID(captain_id : int):
	for captain in captains:
		if captain.id == captain_id:
			return captain

func FindAvailableAICaptain():
	for captain in captains:
		if captain.is_ai and captain.current_piloted_ship_id == -1:
			return captain
			
	return CreateAICaptain()
	
func FindAvailableAIFactionLeader():
	for captain in captains:
		if captain.is_ai and captain.faction == null:
			print("captain found! " + captain.name)
			return captain
			
	return CreateAICaptain()
	
func GetCaptainsCommand():
	var captains_string = ""
	for captain in captains:
		if captain.faction == null:
			captains_string += str("id: ", captain.id, " name: ", captain.name, " is_ai: ", captain.is_ai, "\n")
		else:
			captains_string += str("id: ", captain.id, " name: ", captain.name, " is_ai: ", captain.is_ai, " faction_alliegence: ", captain.faction.name, "\n")
	return captains_string
