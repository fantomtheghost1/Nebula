extends Control

@export var password_window : Control
var oid = ""

func SetServer(server_name : String, server_oid : String, server_password : String, player_count : int, player_count_limit : int):
	oid = server_oid
	%ServerName.text = server_name
	%PlayerCount.text = "%s/%s" % [player_count, player_count_limit]
	if server_password != "":
		%PasswordProtected.visible = true
	
func HandleResponse(response : bool):
	if response == true:
		password_window.visible = false
		MultiplayerManager.Join()
	else:
		print_rich("[color=light_blue]Please try another server...")
	
func _on_join_pressed() -> void:
	if %PasswordProtected.visible:
		password_window.visible = true
		password_window.SetPasswordWindow(oid, self)
	else:
		GlobalVariables.server_browser_http.CanJoin(oid, "", self)
