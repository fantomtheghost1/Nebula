extends Control

@export var server_settings : Control
@export var main_menu : Control

func _ready():
	%ServerBrowserHandler.main_menu = main_menu

func _on_host_pressed() -> void:
	DisableAPICalls()
	mouse_filter = MOUSE_FILTER_IGNORE
	hide()
	
	server_settings.mouse_filter = MOUSE_FILTER_STOP
	server_settings.show()
	
func _on_back_pressed() -> void:
	DisableAPICalls()
	hide()
	mouse_filter = MOUSE_FILTER_IGNORE
	
	main_menu.show()
	main_menu.mouse_filter = main_menu.MOUSE_FILTER_STOP
	
func RemoveServer(oid) -> void:
	%ServerBrowserHandler.RemoveServer(oid)
	
func EnableAPICalls():
	if !OS.has_feature("dedicated_server"):
		%ServerListUpdateInterval.start()

func DisableAPICalls():
	%ServerListUpdateInterval.stop()

func _on_username_text_changed(new_text: String) -> void:
	GlobalVariables.username = new_text
