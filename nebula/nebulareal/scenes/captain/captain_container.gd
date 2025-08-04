# Manages the creation and querying of captain instances in the game
# Extends Node3D to allow captains to be positioned in a 3D scene
extends Node3D

# Preloads the captain instance scene for instantiation
var captain_instance : PackedScene = preload("res://scenes/captain/captain_instance.tscn")
# Tracks the next available ID for AI captains
var next_ai_captain_id : int = 0

# Creates a new captain instance, either AI or player-controlled
# Parameters:
# - is_ai: Boolean indicating if the captain is AI-controlled
# - captain_id: Unique ID for the captain (required for non-AI captains)
# - captain_name: Name for the captain (used for non-AI captains)
@rpc("any_peer", "call_local")
func CreateCaptain(is_ai : bool, captain_id : int = 0, captain_name : String = ""):
	# Check if a captain with the given ID already exists to prevent duplicates
	if FindCaptainByID(captain_id) != null:
		return
		
	# Validate that non-AI captains have a valid captain_id
	if !is_ai and captain_id == 0:
		push_error("If captain is not an ai, captain id must be passed.")
		return
		
	# Instantiate a new captain from the preloaded scene
	var new_captain = captain_instance.instantiate()
	# Add the captain as a child node to this Node3D
	add_child(new_captain, true)
	
	# Configure properties for AI-controlled captains
	if is_ai:
		new_captain.ai_id = next_ai_captain_id
		new_captain.is_ai = true
		new_captain.captain_name = "AI_Captain_" + str(next_ai_captain_id)
		new_captain.name = "AI_Captain_" + str(next_ai_captain_id)
		# Increment the AI ID counter for the next AI captain
		next_ai_captain_id += 1
	# Configure properties for player-controlled captains
	else:
		new_captain.pid = captain_id
		new_captain.captain_name = captain_name
		new_captain.name = captain_name
		
	# Return the newly created captain instance
	return new_captain

# Finds a captain by their ID (either AI or player ID)
# Parameters:
# - captain_id: The ID to search for
# Returns: The captain Node3D if found, null otherwise
func FindCaptainByID(captain_id : int) -> Node3D:
	# Iterate through all child nodes (captains)
	for captain in get_children():
		# Skip the MultiplayerSpawner node
		#if captain == %MultiplayerSpawner:
		#	continue
		# Check AI captains by ai_id
		if captain.is_ai:
			if captain.ai_id == captain_id:
				return captain
		# Check player captains by pid
		elif captain.pid == captain_id:
			return captain
	# Return null if no captain is found
	return null
	
@rpc("any_peer", "call_local")
func RemoveCaptain(captain_id : int) -> void:
	var captain = FindCaptainByID(captain_id)
	var faction = GlobalVariables.faction_container.FindFactionByName(captain.faction_name)
	if faction:
		faction.KickMember.rpc(captain_id)
	
	captain.set_multiplayer_authority(-1)
	captain.queue_free()
	
func SetCredits(captain_id : int, amount : int):
	FindCaptainByID(captain_id).credits = amount

# Retrieves a list of all player-controlled captain names
# Returns: An array of captain names (excluding AI captains)
func GetAllPlayerCaptainNames():
	var names = []
	# Iterate through all child nodes (captains)
	for captain in get_children():
		# Skip the MultiplayerSpawner node
		#if captain == %MultiplayerSpawner:
		#	continue
		# Skip AI captains
		if captain.is_ai:
			continue
		# Add player captain names to the list
		names.append(captain.captain_name)
	return names

# Generates a string summarizing all captains' details
# Returns: A formatted string with details for each captain
func GetCaptainsCommand():
	var captains = ""
	# Iterate through all child nodes (captains)
	for captain in get_children():
		# Skip the MultiplayerSpawner node
		#if captain == %MultiplayerSpawner:
		#	continue
		# Format details for non-AI captains
		if !captain.is_ai:
			captains += str("PID: %s | Name: %s | Faction Affiliation: %s | Credits: %s | Is AI: %s\n" % [captain.pid, captain.name, captain.faction_name, captain.credits, captain.is_ai])
		# Format details for AI captains
		else:
			captains += str("AI ID: %s | Name: %s | Faction Affiliation: %s | Credits: %s | Is AI: %s\n" % [captain.ai_id, captain.name, captain.faction_name, captain.credits, captain.is_ai])
	return captains

func GetAllCaptainData():
	var data = {}
	var index = 0
	for captain in get_children():
		#if captain == %MultiplayerSpawner:
		#	continue
		data[index] = {
			"pid": captain.pid,
			"captain_name": captain.captain_name,
			"faction_name": captain.faction_name,
			"credits": captain.credits,
			"is_ai": captain.is_ai,
			"ai_id": captain.ai_id,
			"node_path": str(captain.get_path())
		}
		index += 1
	return data
