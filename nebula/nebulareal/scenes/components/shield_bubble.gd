extends Node3D


# Reference to the parent ship node
var ship_node = null


# Enum defining possible shield bubble statuses
enum STATUS {ACTIVE, INACTIVE}


# Current status of the shield bubble
var current_status = STATUS.INACTIVE

# Current shield points
@export var sp = 0

# Maximum shield points
var max_sp = 0

# Amount of shield points regained per recharge tick
var recharge_amount = 0

# Duration of each recharge tick in seconds
var recharge_tick = 0.0

# Delay before shield recharge begins
var recharge_delay = 0.0

# Flag indicating if the shield is currently recharging
var recharging = false


# Absorbs incoming damage and returns any excess damage
func AbsorbDamage(damage):
	sp -= damage
	print_debug("[color=orange][ShieldBubble] ", ship_node.name, "'s SP: ", sp, "[/color]")
	if sp <= 0:
		print_rich("[color=orange][ShieldBubble] ", ship_node.name, "'s shield is down![/color]")
		return sp
	return 0
	
func DisableShield():
	current_status = STATUS.INACTIVE
	%RechargeDelay.stop()
	%RechargeTick.stop()
	sp = 0
	recharging = false

func EnableShield():
	current_status = STATUS.ACTIVE
	sp = 0
	recharging = false

# Checks if shield needs recharging during process loop
func _process(_delta):
	if sp < max_sp and not recharging and current_status != STATUS.INACTIVE:
		recharging = true
		%RechargeDelay.wait_time = recharge_delay
		%RechargeDelay.start()


# Starts the recharge tick timer after the delay
func _on_recharge_delay_timeout():
	%RechargeTick.wait_time = recharge_tick
	%RechargeTick.start()


# Recharges shield points on each tick
func _on_recharge_tick_timeout():
	if sp < 0:
		sp = 0
	
	if sp != max_sp:
		sp += recharge_amount
		print_debug("[color=orange][ShieldBubble] ", ship_node.name, "'s SP: ", sp, "[/color]")
	else:
		%RechargeTick.stop()
		recharging = false
