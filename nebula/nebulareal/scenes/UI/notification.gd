extends Control

@export var server_browser_http : Node3D

# Called when the node enters the scene tree for the first time.
func _on_enter_pressed() -> void:
	JoinWithPassword
