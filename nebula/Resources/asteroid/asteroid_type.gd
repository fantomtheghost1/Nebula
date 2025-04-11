extends Resource
class_name AsteroidType

## Holds the asteroid's item composition resource.
@export var composition : Resource

## Holds the amount of ore present in the asteroid until it is destroyed.
@export var ore : int

## Holds the physical scale of the asteroid so that different sized asteroids can be represented appropriately in-game.
@export var scale : float

## Holds the asteroid mesh instance
@export var asteroid_mesh : Mesh
