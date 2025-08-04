extends VBoxContainer

var server_instance = preload("res://scenes/UI/ServerBrowserInstance.tscn")

func _ready():
	if !OS.has_feature("dedicated_server"):
		%ServerBrowserHandler.GetServers()

func ClearServers():
	for child in get_children():
		child.queue_free()

func AddServer(server):
	var instance = server_instance.instantiate()
	add_child(instance)
	instance.password_window = %Password
	instance.SetServer(server["server_name"], server["server_ip"], server["server_password"], server["player_count"], server["player_count_limit"])

func _on_server_list_update_interval_timeout() -> void:
	%ServerBrowserHandler.GetServers()
