extends Control

var chat_message_instance = preload("res://scenes/UI/text_instance.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ChatEnter") and !GlobalVariables.input_disabled and %ChatLineEdit.text == "":
		visible = !visible
		%ChatLineEdit.grab_focus()
		%ChatLineEdit.accept_event()
	elif event.is_action_pressed("ChatEnter") and !GlobalVariables.input_disabled and %ChatLineEdit.text != "":
		if GlobalVariables.client_captain == null:
			GlobalVariables.client_captain = GlobalVariables.captain_container.FindCaptainByID(multiplayer.multiplayer_peer.get_unique_id())
		CreateChatMessage.rpc(GlobalVariables.client_captain.captain_name, %ChatLineEdit.text)
		%ChatLineEdit.text = ""
		%ChatLineEdit.grab_focus()
		%ChatLineEdit.accept_event()

@rpc("any_peer", "call_local", "reliable")
func CreateChatMessage(username : String, message : String):
	var new_message = chat_message_instance.instantiate()
	new_message.text = "%s: %s" % [username, message]
	%ChatBox.add_child(new_message)
