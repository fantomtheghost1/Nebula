extends LineEdit

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DevConsole"):
		visible = !visible
		print("toggling console")
 
	if event.is_action_pressed("DevConsoleEnter"):
		var console_input = text.split(" ")
		text = ""
		
		print(console_input)
