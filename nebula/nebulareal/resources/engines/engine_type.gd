extends Resource
class_name EngineType

## Holds the name of the engine type.
@export var name : String

## Holds the max hp of the engine.
@export var max_hp : int

## Holds the maximum speed that the engine allows the ship to move at.
@export var max_speed : float

## Holds the initial speed that the engine starts at before acceleration.
@export var initial_speed : float

## Holds the amount of speed that gets added to the initial speed after prolonged engine use.
@export var acceleration : float
