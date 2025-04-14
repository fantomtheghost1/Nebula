extends Node3D

var connection = null
var ship_container : Node3D

func Initialize(connection_param):
	connection = connection_param
	print(connection)

func Warp(subject):
	AchievementManager.ProgressAchievement("DEBUG_RELAY", 1)
	subject.position = Vector3(connection.position.x - 150, 0 , connection.position.z - 150)
	subject.call_deferred("reparent", connection.ship_container)
	print("warping to " + str(Vector3(connection.position.x - 150, 0 , connection.position.z - 150)))
