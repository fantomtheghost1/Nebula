extends Node3D

var ItemScript : Script = preload("res://Classes/Item.gd")

@export var generator_type : String = ""
@export var cargo_bay_type : String = ""
@export var shield_generator_type : String = ""
@export var id : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ShieldGenerator.SetShieldGenerator(shield_generator_type)
	%CargoComponent.SetCargoBay(cargo_bay_type)
	%GeneratorComponent.SetGenerator(generator_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
