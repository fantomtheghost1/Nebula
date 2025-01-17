extends Node3D

# this enumerator holds all the possible statuses that the shield bubble can be in
enum STATUS {ACTIVE, INACTIVE}

# represents the current status of the shield bubble
var current_status = STATUS.INACTIVE

# represents the current amount of shield hit points the bubble has currently
var sp = 0

# represents the max amount of shield hit points the bubble has
var max_sp = 0

# represents the amount of shield that is regained per tick
var recharge_amount = 0

# represents how long a tick lasts
var recharge_tick = 0.0

# represents the delay before the shield bubble begins recharging
var recharge_delay = 0.0

# represents whether the shield bubble is currently recharging
var recharging = false

func AbsorbDamage(damage):
	sp -= damage
	print(get_parent().get_parent().name + "shield: " + str(sp))
	if sp <= 0:
		print(get_parent().get_parent().name + " shield down!")
		return sp
	else:
		return 0
		
func _process(_delta):
	if sp < max_sp and !recharging and current_status != STATUS.INACTIVE:
		recharging = true
		%RechargeDelay.wait_time = recharge_delay
		%RechargeDelay.start()
		#print(shield_amount)

func _on_recharge_delay_timeout():
	%RechargeTick.wait_time = recharge_tick
	%RechargeTick.start()

func _on_recharge_tick_timeout():
	if sp < 0:
		sp = 0
		
	if sp != max_sp:
		sp += recharge_amount
		print(get_parent().get_parent().name + " shield: " + str(sp))
	else:
		%RechargeTick.stop()
		recharging = false

func _on_shield_generator_shield_generator_disabled(ship_node):
	if ship_node == get_parent().get_parent():
		print(sp)
		current_status = STATUS.INACTIVE
		%RechargeDelay.stop()
		%RechargeTick.stop()
		sp = 0
		recharging = false

func _on_shield_generator_shield_generator_enabled(ship_node):
	if ship_node == get_parent().get_parent():
		current_status = STATUS.ACTIVE
		sp = 0
		recharging = false
