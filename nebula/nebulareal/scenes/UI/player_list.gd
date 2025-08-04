extends Control

var player_item = preload("res://scenes/UI/player_item.tscn")

@rpc("authority", "call_local", "reliable")
func PopulatePlayerList():
	for player_name in %PlayerListContainer.get_children():
		player_name.queue_free()
		
	for player_name in GlobalVariables.captain_container.GetAllPlayerCaptainNames():
		if player_name != "":
			var player_item_instance = player_item.instantiate()
			%PlayerListContainer.add_child(player_item_instance)
			player_item_instance.get_node("Label").text = " %s " % player_name
