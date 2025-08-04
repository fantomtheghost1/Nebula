extends Control
	
func SetMenu(build_version : String, update_header : String):
	%MainHeaderLabel.text = "Nebula %s | %s" % [build_version, update_header] 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#func _on_button_pressed() -> void:
#	%ServerBrowser.show()
#	%ServerBrowser.mouse_filter = %ServerBrowser.MOUSE_FILTER_STOP
#	%ServerBrowser.EnableAPICalls()
#	
#	mouse_filter = MOUSE_FILTER_IGNORE
#	hide()

func _on_button_2_pressed() -> void:
	get_tree().quit()

func _on_quick_play_pressed() -> void:
	MultiplayerManager.Join()
	GlobalVariables.username = %Username.text

func _on_server_browser_pressed() -> void:
	hide()
	GlobalVariables.server_browser.show()
	%ServerBrowser.EnableAPICalls()

func _on_settings_pressed() -> void:
	hide()
	GlobalVariables.settings.show()

func _on_username_text_changed(new_text: String) -> void:
	GlobalVariables.username = new_text
