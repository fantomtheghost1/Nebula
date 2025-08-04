extends Node3D

@export var damageable_components : Array[Node]
@export var parent_node : Node3D

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var shot_hit_text = preload("res://scenes/UI/shot_hit_text.tscn")

# Handle damage taken by ship
@rpc("any_peer", "call_local")
func TakeDamage(damage : int, accuracy : float, is_command : bool = false):
	if !is_command:
		if accuracy > rng.randf_range(0, 1):
			if %ShieldGenerator.component_status != %ShieldGenerator.STATUS.CRIPPLED:
				# Apply damage to shield and handle overflow
				var overflow = %ShieldGenerator.DamageComponent(damage)
				var shield_text = shot_hit_text.instantiate()
				%ShotHit.add_child(shield_text)
				shield_text.text = "Shot hit for " + str(overflow) + " damage!"
				shield_text.label_settings.font_color = Color(0.45, 0.99, 0.94, 1)
				parent_node.is_repaired = false
				
				if overflow > 0:
					# Apply overflow damage to random component
					HitRandomComponent(overflow)
					var hit_text = shot_hit_text.instantiate()
					%ShotHit.add_child(hit_text)
					hit_text.text = "Chassis hit for " + str(overflow) + " damage!"
					hit_text.label_settings.font_color = Color(1, 0.26, 0.31, 1)
					parent_node.is_repaired = false
			else:
				# Apply damage to random component if no shield
				HitRandomComponent(damage)
				var new_text = shot_hit_text.instantiate()
				%ShotHit.add_child(new_text)
				new_text.text = "Shot hit for " + str(damage) + " damage!"
				new_text.label_settings.font_color = Color(1, 0.26, 0.31, 1)
				parent_node.is_repaired = false
		else:
			# Display miss message
			var new_text = shot_hit_text.instantiate()
			%ShotHit.add_child(new_text)
			new_text.text = "Shot missed!"
			new_text.label_settings.font_color = Color(1, 1, 1, 1)
	else:
		# Apply direct damage to random component
		HitRandomComponent(damage)
		parent_node.is_repaired = false
	
# Apply damage to a random component
func HitRandomComponent(damage):
	var component = damageable_components.pick_random()
	component.DamageComponent(damage)
