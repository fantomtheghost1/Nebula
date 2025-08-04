# Defines the Captain class, representing a captain entity in the game
# Extends Node3D to position the captain in a 3D scene
class_name Captain
extends Node3D

# Unique player ID for non-AI captains, defaults to -1 if not set
@export var pid : int = -1
# Name of the captain, customizable via the editor
@export var captain_name : String = ""
# Name of the faction the captain is affiliated with
@export var faction_name : String = ""
# Amount of credits (currency) the captain possesses
@export var credits : int = 0

# Indicates whether the captain is AI-controlled
@export var is_ai : bool = false
# Unique AI ID for AI-controlled captains, defaults to -1 if not set
@export var ai_id : int = -1

# Reference to the currently piloted object (e.g., a ship), null if none
var current_piloted_object : Node3D = null

# Array to store the captain's ship inventory, holding Resource objects
var ship_inventory : Array[Resource] = []
