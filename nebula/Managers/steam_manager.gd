extends Node

var user_id = null
var steam_username = null

func _ready() -> void:
	Steam.steamInit()
	if !Steam.isSteamRunning():
		print("steam has crashed and burned, polease fix that")
		return
		
	user_id = Steam.getSteamID()
	steam_username = Steam.getFriendPersonaName(user_id)
		
	print("Steam is initialized!")
	print("Your steam username is " + steam_username + "\n")

func GetSteamUsername():
	return steam_username
	
func GetSteamUID():
	return user_id
