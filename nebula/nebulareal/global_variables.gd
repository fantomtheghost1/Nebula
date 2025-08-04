extends Node

# node references
var camera_gimbal : Node3D = null
var camera : Node3D = null
var main_scene : Node3D = null
var server_browser_http : HTTPRequest
var server_ping_interval : Timer

# UI references
var faction_menu : Control
var player_list : Control
var chat : Control
var main_menu : Control
var server_browser : Control
var settings : Control

# container references
var faction_container : Node3D
var captain_container : Node3D

# dev options
var dev_mode : bool = true
var host_mode : bool = false

# client variables
var client_captain : Node3D
var username : String

# helper variables
var generic_tween_time : float = 2.0
var input_disabled : bool = false
