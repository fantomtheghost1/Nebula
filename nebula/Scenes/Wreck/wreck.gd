extends Node3D

var object_type : String = "wreck"
var salvage_time : float = 4.0
var wreck_loot = {}
var wreck_size = ""

func Initialize(loot : Dictionary):
	wreck_loot = loot
