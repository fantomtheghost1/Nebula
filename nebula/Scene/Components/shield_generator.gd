extends Node3D

#@export var generator_health : int = 0
@export var max_shield : int = 0
@export var recharge_delay : float = 0.0
@export var recharge_tick : float = 0.0

var current_shield = 0

func _ready():
	current_shield = max_shield
	print("Shield: " + str(current_shield))

func TakeDamage(damage):
	current_shield -= damage
	print("shield: " + str(current_shield))
	%RechargeDelay.wait_time = recharge_delay
	%RechargeDelay.start()
	if current_shield <= 0:
		print("Shield down!")
		return current_shield
	else:
		return 0

func _on_recharge_delay_timeout():
	%RechargeTick.wait_time = recharge_tick
	%RechargeTick.start()
	
func _on_recharge_tick_timeout():
	if current_shield < 0:
		current_shield = 0
		
	if current_shield != max_shield:
		current_shield += 2
		print("shield: " + str(current_shield))
		if %RechargeTick.wait_time - 0.05 > 0:
			%RechargeTick.wait_time -= 0.05
	else:
		%RechargeTick.stop()

func _on_turret_beam_fired(turret_owner, target, damage):
	if target == "test":
		TakeDamage(damage)
