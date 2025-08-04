extends Node

func OpCommand(captain_id : int) -> String:
	var captain = GlobalVariables.captain_container.FindCaptainByID(captain_id)
	if captain:
		Console._admins.append(captain.captain_name)
		var file = FileAccess.open("res://admins.txt", FileAccess.READ_WRITE)
		file.seek_end()
		file.store_string(captain.captain_name)
		file.close()
		return "Captain %s has now been opped!" % captain.captain_name
	return "Captain was not found: %s" % captain_id

func KickCommand(captain_id : int) -> String:
	var captain = GlobalVariables.captain_container.FindCaptainByID(captain_id)
	if captain:
		MultiplayerManager.DisconnectPlayer(captain_id)
		return "Captain %s has now been kicked!" % captain.captain_name
	return "Captain was not found: %s" % captain_id
