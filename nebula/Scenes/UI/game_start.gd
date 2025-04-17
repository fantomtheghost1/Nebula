extends Control

#func _ready():
	#%Welcome.text = "Welcome, " + SteamManager.client.name + "!"

func _on_create_faction_pressed() -> void:
	%FactionList.visible = false
	%CreateFaction.visible = true

func _on_create_pressed() -> void:
	var new_faction = Faction.new(%LineEdit.text, %ColorPickerButton.color, SteamManager.client)
	FactionManager.AddFaction(new_faction)
	SteamManager.client.SetPlayerFaction(new_faction)
	#FactionManager.AllyWithFaction(new_faction.name, "AIFaction")
	visible = false
	GlobalVariables.input_disabled = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
