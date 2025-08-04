extends Node3D

var repair_tick : int
var repair_amount : int

func Init(level):
	repair_tick = 1
	repair_amount = 10 * level

func StartRepairs():
	%RepairTick.wait_time = repair_tick
	%RepairTick.start()
	
func StopRepairs():
	%RepairTick.stop()

func _on_repair_tick_timeout() -> void:
	if !GameManager.GetClientShip().is_repaired:
		GameManager.GetClientShip().RepairShip(repair_amount)
	else:
		%RepairTick.stop()
