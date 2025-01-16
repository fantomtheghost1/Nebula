extends Node3D

enum STATUS {ACTIVE, INACTIVE}

var current_status = STATUS.INACTIVE
var shield_amount = 0
var max_shield = 0
var recharge_amount = 0
var recharge_tick = 0.0
var recharge_delay = 0.0
var recharging = false

func AbsorbDamage(damage):
	shield_amount -= damage
	print("shield: " + str(shield_amount))
	if shield_amount <= 0:
		print("Shield down!")
		return shield_amount
	else:
		return 0
		
func _process(_delta):
	if shield_amount < max_shield and !recharging and current_status != STATUS.INACTIVE:
		recharging = true
		%RechargeDelay.wait_time = recharge_delay
		%RechargeDelay.start()
		#print(shield_amount)

func _on_recharge_delay_timeout():
	%RechargeTick.wait_time = recharge_tick
	%RechargeTick.start()

func _on_recharge_tick_timeout():
	if shield_amount < 0:
		shield_amount = 0
		
	if shield_amount != max_shield:
		shield_amount += recharge_amount
		print("shield: " + str(shield_amount))
	else:
		%RechargeTick.stop()
		recharging = false

func _on_shield_generator_shield_generator_disabled(ship_node):
	if ship_node == get_parent().get_parent():
		print("disabled")
		print(shield_amount)
		current_status = STATUS.INACTIVE
		%RechargeDelay.stop()
		%RechargeTick.stop()
		shield_amount = 0
		recharging = false

func _on_shield_generator_shield_generator_enabled(ship_node):
	if ship_node == get_parent().get_parent():
		print("enabled")
		current_status = STATUS.ACTIVE
		shield_amount = 0
		recharging = false
