extends Control

@export var server_browser_instance : Control
@export var oid : String

func SetPasswordWindow(new_oid, server_instance):
	oid = new_oid
	server_browser_instance = server_instance

# Called when the node enters the scene tree for the first time.
func _on_enter_pressed() -> void:
	GlobalVariables.server_browser_http.CanJoin(oid, %PasswordLE.text, server_browser_instance)
	
func _on_back_pressed() -> void:
	hide()
