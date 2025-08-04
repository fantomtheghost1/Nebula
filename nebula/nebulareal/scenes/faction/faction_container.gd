# Manages faction creation, membership, and diplomacy in a multiplayer 3D game
# Extends Node3D to position factions in the scene tree
extends Node3D

# Array to store all active faction instances
var factions: Array = []

# Preloaded faction scene for instantiating new factions
var faction_instance = preload("res://scenes/faction/faction_instance.tscn")

# Counter for assigning unique IDs to factions
var next_faction_id: int = 0

# Requests faction creation on the server, callable from any peer
# Parameters:
# - faction_name: The desired name of the new faction
# - faction_color: The color representing the faction
# - faction_leader: The player ID of the faction's leader
@rpc("any_peer", "call_local")
func RequestCreateFaction(faction_name: String, faction_color: Color, faction_leader: int) -> void:
	# Ensure only the server processes faction creation
	if not multiplayer.is_server():
		return

	# Prevent duplicate faction names in the scene tree
	if has_node(faction_name):
		push_error("Error: Faction name \'%s\' already exists..." % faction_name)
		return

	# Create a new faction instance from the preloaded scene
	var new_faction = faction_instance.instantiate()
	
	# Add the faction to the scene tree with its name as the node name
	add_child(new_faction, true)
	
	new_faction.Init.rpc(faction_name, faction_color, faction_leader)

	# Store the faction in the factions array
	factions.append(new_faction)

	# Update diplomacy relationships for all factions
	UpdateDiplomacy.rpc()

	# Increment the unique faction ID counter
	next_faction_id += 1

	# Update the faction leader's faction affiliation in the captain container
	GlobalVariables.captain_container.FindCaptainByID(faction_leader).faction_name = faction_name

	# Ensure the leader is only in the new faction
	ClearMemberFromOtherFactions.rpc(faction_name, faction_leader)

	# Notify the client of successful faction creation
	GlobalVariables.faction_menu.CreateFactionResponse.rpc_id(faction_leader)
	
	new_faction.set_multiplayer_authority(1)
	
@rpc("any_peer", "call_local")
func JoinFaction(faction_name: String, new_faction_member: int):
	for faction in get_children():
		if faction == %MultiplayerSpawner:
			continue
		if faction.faction_name == faction_name:
			faction.AddMember.rpc(new_faction_member)
			GlobalVariables.faction_menu.hide()
			GlobalVariables.input_disabled = false

# Removes a captain from all other factions to enforce single-faction membership
# Parameters:
# - new_faction: The faction the captain is joining
# - old_member_id: The player ID of the captain to remove from other factions
@rpc("any_peer", "call_local")
func ClearMemberFromOtherFactions(faction_name: String, old_member_id: int) -> void:
	# Iterate through all existing factions
	for faction in factions:
		if faction == %MultiplayerSpawner:
			continue
		# Check if the faction has the captain as its leader and is not the new faction
		if faction.faction_leader == old_member_id and faction.faction_name != faction_name:
			# Remove the captain from the old faction
			faction.RemoveMember(old_member_id)
			# Delete the faction if it has no members left
			if faction.faction_members == []:
				faction.queue_free()
			# Assign a new AI leader if the faction still has members
			else:
				var new_leader = GlobalVariables.captain_container.CreateCaptain.rpc(true)
				faction.faction_leader = new_leader
				faction.AddMember.rpc(new_leader)
		
@rpc("any_peer", "call_local")
func RemoveFaction(faction_name : String) -> void:
	var index = 0
	for faction in factions:
		if faction.faction_name == faction_name:
			factions.erase(index)
			faction.queue_free()
		index += 1

# Updates diplomacy states for all factions
@rpc("any_peer", "call_local")
func UpdateDiplomacy() -> void:
	var faction_names = []
	for faction in factions:
		faction_names.append(faction.faction_name)
	# Call UpdateDiplomacy on each faction, passing the list of all factions
	for faction in factions:
		faction.UpdateDiplomacy.rpc(faction_names)
		
func FindFactionByName(faction_name : String):
	for faction in factions:
		if faction.faction_name == faction_name:
			return faction

# Checks if two factions are allied or the same
# Parameters:
# - faction_name_one: Name of the first faction
# - faction_name_two: Name of the second faction
# Returns: True if the factions are allied or identical, false otherwise
func AreFactionsAllied(faction_name_one: String, faction_name_two: String) -> bool:
	# Return true if both factions are the same
	if faction_name_one == faction_name_two:
		return true

	var faction_one = null
	# Find the first faction by name
	for faction in factions:
		if faction == %MultiplayerSpawner:
			continue
		if faction.faction_name == faction_name_one:
			faction_one = faction
			break

	var diplomacy = null
	# Check the diplomacy state of the second faction in the first faction's diplomacy dictionary
	if faction_one:
		for faction_name in faction_one.diplomacy:
			if faction_name == faction_name_two:
				diplomacy = faction_one.diplomacy[faction_name]
				break

	# Return true if the diplomacy state is ALLY (0)
	return diplomacy == 0
	
func GetFactions():
	var faction_list = []
	# Iterate through all child nodes (factions)
	for faction in get_children():
		# Skip the MultiplayerSpawner node
		if faction == %MultiplayerSpawner:
			continue
		# Append formatted faction details
		faction_list.append(faction)
	return faction_list

# Generates a formatted string summarizing all factions' details
# Returns: A string listing faction names, leaders, and members
func GetFactionsCommand() -> String:
	var factions_string = ""
	# Iterate through all child nodes (factions)
	for faction in get_children():
		# Skip the MultiplayerSpawner node
		if faction == %MultiplayerSpawner:
			continue
		# Append formatted faction details
		factions_string += str(
			"Faction Name: %s | Faction Leader: %s | Faction Members: %s\n" % [
				faction.faction_name,
				faction.faction_leader,
				faction.faction_members
			]
		)
	return factions_string

# Adds a captain to a specified faction
# Parameters:
# - faction_name: Name of the faction to join
# - captain_id: ID of the captain joining the faction
func JoinFactionCommand(faction_name: String, captain_id: int) -> void:
	JoinFaction.rpc(faction_name, captain_id)

func GetAllFactionData():
	var data = {}
	var index = 0
	for faction in get_children():
		if faction == %MultiplayerSpawner:
			continue
		data[index] = {
			"faction_name": faction.faction_name,
			"faction_leader": faction.faction_leader,
			"faction_color": faction.faction_color,
			"faction_members": faction.faction_members,
			"diplomacy": faction.diplomacy,
			"node_path": str(faction.get_path())
		}
		index += 1
	return data
