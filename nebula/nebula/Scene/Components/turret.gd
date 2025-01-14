extends Node3D

signal BeamFired(turret_owner, target, damage)

func FireBeam(turret_owner, target, damage):
	BeamFired.emit("me", "test", 1000)
	print("Beam fired from " + str(turret_owner) + " at the target " + str(target) + " for " + str(damage) + " damage!")

func _ready():
	FireBeam("me", "test", 1000)
