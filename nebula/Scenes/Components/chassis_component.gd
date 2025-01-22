extends Node3D

signal ChassisDestroyed(ship_node)

var hp : int = 0
var chassis_type : String = ""
var destroyed : bool = false

const CHASSIS_TYPES : Dictionary = {
	"RUNABOUT_CHASSIS":{"HP":100},
	"FRIGATE_CHASSIS":{"HP":200},
	"DESTROYER_CHASSIS":{"HP":300},
	"CRUISER_CHASSIS":{"HP":400},
	"BATTLESHIP_CHASSIS":{"HP":500},
	"DREADNOUGHT_CHASSIS":{"HP":600},
	"HQ_CHASSIS":{"HP":100},
	"DUMMY_ZERO_CHASSIS":{"HP":0}
}

func SetChassisType(chassis : String):
	hp = CHASSIS_TYPES[chassis]["HP"]
	chassis_type = chassis
	
	if hp <= 0:
		DestroyComponent()

func DamageComponent(damage) -> void:
	hp -= damage
	# if the component hp is depleted and the component hasn't been destroyed yet
	if hp <= 0 and !destroyed:
		DestroyComponent()
		
func DestroyComponent() -> void:
	destroyed = true
	
	# generates a signal that passes the parent ship node as a parameter
	ChassisDestroyed.emit(get_parent())
