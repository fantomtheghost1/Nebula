extends Node3D

signal turret_state_changed(turret : Node3D)

# Number of mining turrets available on the ship
@export var number_of_turrets : int

# Tier level of the mining turrets, determining which asteroids can be mined
@export var turret_tier : int

func Init():
	for turret in get_children():
		turret.connect("turret_state_changed", _on_turret_state_changed)

# Handles input events for toggling mining turret activation
func _input(event):
	# Check if a target is set and is an asteroid
	if %TargetingComponent.target and %TargetingComponent.target_type == "asteroid":
		# Ensure the asteroid's mining tier is compatible with the turret tier
		if %TargetingComponent.target.resource.asteroid_mining_tier <= turret_tier:
			# Toggle turrets based on input actions and available turrets
			if event.is_action_pressed("ToggleTurretOne") and number_of_turrets >= 1:
				get_child(0).Activate()
			if event.is_action_pressed("ToggleTurretTwo") and number_of_turrets >= 2:
				get_child(1).Activate()
			if event.is_action_pressed("ToggleTurretThree") and number_of_turrets >= 3:
				get_child(2).Activate()
			if event.is_action_pressed("ToggleTurretFour") and number_of_turrets >= 4:
				get_child(3).Activate()
			if event.is_action_pressed("ToggleTurretFive") and number_of_turrets >= 5:
				get_child(4).Activate()
			if event.is_action_pressed("ToggleTurretSix") and number_of_turrets >= 6:
				get_child(5).Activate()
			if event.is_action_pressed("ToggleTurretSeven") and number_of_turrets >= 7:
				get_child(6).Activate()
			if event.is_action_pressed("ToggleTurretEight") and number_of_turrets >= 8:
				get_child(7).Activate()
			if event.is_action_pressed("ToggleTurretNine") and number_of_turrets == 9:
				get_child(8).Activate()

func _on_turret_state_changed(turret : Node3D):
	turret_state_changed.emit(turret)

func DamageTurret(damage):
	var turret = get_children().pick_random()
	turret.DamageTurret(damage)

func CrippleTurrets():
	for turret in get_children():
		turret.CrippleTurret()
