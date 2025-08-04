# Manages a faction entity in the game, handling membership and diplomacy
# Extends Node3D to allow factions to have a spatial presence in the scene
extends Node3D

# Enum defining possible diplomacy states between factions
enum DIPLOMACY_STATES {ALLY, NEUTRAL, ENEMY}

# Name of the faction, customizable via the editor
@export var faction_name = ""
# ID of the faction's leader, defaults to 0
@export var faction_leader = 0
# Color representing the faction, used for visual identification
@export var faction_color = Color(0, 0, 0)
# Array storing IDs of faction members
@export var faction_members = []
# Dictionary storing diplomacy states with other factions (key: faction name, value: DIPLOMACY_STATES)
@export var diplomacy = {}

@rpc("authority", "call_local", "reliable")
func Init(faction_name_param : String, faction_color_param : Color, faction_leader_param : int):
	# Configure faction properties
	faction_name = faction_name_param
	faction_color = faction_color_param
	faction_leader = faction_leader_param

	# Register the faction leader as a member
	AddMember.rpc(faction_leader_param)

# Adds a new member to the faction by their ID
# Parameters:
# - faction_member_id: The ID of the captain to add
@rpc("any_peer", "call_local")
func AddMember(faction_member_id):
	# Append the member ID to the faction_members array
	faction_members.append(faction_member_id)
	# Retrieve the captain instance from the global captain container
	var new_faction_member = GlobalVariables.captain_container.FindCaptainByID(faction_member_id)
	# Assign the faction's name to the captain's faction_name property
	new_faction_member.faction_name = faction_name

# Removes a member from the faction by their ID
# Parameters:
# - faction_member_id: The ID of the captain to remove
@rpc("call_local", "any_peer")
func KickMember(faction_member_id):
	# Remove the member ID from the faction_members array
	faction_members.erase(faction_member_id)

# Retrieves the list of faction member IDs
# Returns: Array of faction member IDs
func GetMembers():
	return faction_members

# Updates diplomacy relationships with other factions
# Parameters:
# - factions: Array of faction instances to process
@rpc("call_local", "any_peer")
func UpdateDiplomacy(factions : Array):
	# Iterate through all provided factions
	for faction in factions:
		# Skip the current faction to avoid self-referencing
		if faction != faction_name:
			# Set the diplomacy state to NEUTRAL for each other faction
			diplomacy[faction] = DIPLOMACY_STATES.NEUTRAL
