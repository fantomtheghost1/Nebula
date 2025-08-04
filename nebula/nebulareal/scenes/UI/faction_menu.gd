extends Control

var faction_instance = preload("res://scenes/UI/faction_instance.tscn")

func PopulateFactionList():
	var factions = GlobalVariables.faction_container.GetFactions()
	for faction in factions:
		var fact = faction_instance.instantiate()
		%FactionContainer.add_child(fact)
		fact.Init(faction.faction_color, faction.faction_leader, faction.faction_name)

func _on_create_faction_pressed() -> void:
	%FactionList.visible = false
	%CreateFaction.visible = true

func _on_create_pressed() -> void:
	var faction_name = %LineEdit.text.strip_edges()
	if faction_name == "":
		push_error("Error: Faction name cannot be empty")
		return
	print_rich("[color=yellow]Attempting to create faction '%s'" % faction_name)
	GlobalVariables.faction_container.RequestCreateFaction.rpc_id(1, %LineEdit.text, %ColorPickerButton.color, multiplayer.multiplayer_peer.get_unique_id())

@rpc("any_peer", "call_local")
func CreateFactionResponse():
	visible = false
	GlobalVariables.input_disabled = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
