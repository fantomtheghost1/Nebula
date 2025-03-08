extends Node3D

@export var number_of_turrets : int 

func _input(event):
	
	if event.is_action_pressed("ToggleTurretOne") and %TargetingComponent.target and %TargetingComponent.target_type == "asteroid" and number_of_turrets >= 1:
		get_child(0).ToggleActivated()
		
	if event.is_action_pressed("ToggleTurretTwo") and %TargetingComponent.target and %TargetingComponent.target_type == "asteroid" and number_of_turrets >= 2:
		get_child(1).ToggleActivated()
		
	if event.is_action_pressed("ToggleTurretThree") and %TargetingComponent.target and %TargetingComponent.target_type == "asteroid" and number_of_turrets >= 3:
		get_child(2).ToggleActivated()
		
	if event.is_action_pressed("ToggleTurretFour") and %TargetingComponent.target and %TargetingComponent.target_type == "asteroid" and number_of_turrets >= 4:
		get_child(3).ToggleActivated()
		
	if event.is_action_pressed("ToggleTurretFive") and %TargetingComponent.target and %TargetingComponent.target_type == "asteroid" and number_of_turrets >= 5:
		get_child(4).ToggleActivated()
		
	if event.is_action_pressed("ToggleTurretSix") and %TargetingComponent.target and %TargetingComponent.target_type == "asteroid" and number_of_turrets >= 6:
		get_child(5).ToggleActivated()
		
	if event.is_action_pressed("ToggleTurretSeven") and %TargetingComponent.target and %TargetingComponent.target_type == "asteroid" and number_of_turrets >= 7:
		get_child(6).ToggleActivated()
		
	if event.is_action_pressed("ToggleTurretEight") and %TargetingComponent.target and %TargetingComponent.target_type == "asteroid" and number_of_turrets >= 8:
		get_child(7).ToggleActivated()
		
	if event.is_action_pressed("ToggleTurretNine") and %TargetingComponent.target and %TargetingComponent.target_type == "asteroid" and number_of_turrets == 9:
		get_child(8).ToggleActivated()
