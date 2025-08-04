extends Control

func Init(faction_color, faction_leader, faction_name):
	var captain = GlobalVariables.captain_container.FindCaptainByID(faction_leader)
	if captain:
		%FactionColor.color = Color(faction_color, 0.5)
		%FactionLeader.text = "Led by %s" % captain.captain_name
		%FactionName.text = faction_name
	else:
		GlobalVariables.faction_container.RemoveFaction(faction_name)
		queue_free()

func _on_button_pressed() -> void:
	GlobalVariables.faction_container.JoinFaction.rpc(%FactionName.text, multiplayer.get_unique_id())
