extends Node3D

func CheckIsAI(is_npc):
	if !is_npc:
		queue_free()
