extends Control

@export var turrets : Array[ColorRect]

func Init():
	for turret in turrets:
		turret.show()

func ActivateTurret(turret : Node3D) -> void:
	if turret.turret_status == turret.STATUS.ENABLED:
		var turret_instance = turrets[turret.id - 1]
		turret_instance.color = Color(0, 0, 0, 0.76)
		
		var activation_color = Color(0.19, 0.42, 0.13, 0.8)
		turret_instance.get_node("MarginContainer/ColorRect").color = activation_color
		
	if turret.turret_status == turret.STATUS.DISABLED:
		var turret_instance = turrets[turret.id - 1]
		turret_instance.color = Color(0, 0, 0, 0.43)
		
		var activation_color = Color(0.34, 0.34, 0.34, 0.67)
		turret_instance.get_node("MarginContainer/ColorRect").color = activation_color

func _on_mining_container_turret_state_changed(turret: Node3D) -> void:
	ActivateTurret(turret)

func _on_combat_container_turret_state_changed(turret: Node3D) -> void:
	ActivateTurret(turret)
