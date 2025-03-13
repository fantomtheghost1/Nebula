extends Resource
class_name AsteroidType

## Holds the asteroid's composition. 0 = METAL, 1 = SILICON, 2 = ISOTOPES, 3 = ICE, 4 = GOLD.
@export var composition : int

## Holds the amount of ore present in the asteroid until it is destroyed.
@export var ore : int

## Holds the physical scale of the asteroid so that different sized asteroids can be represented appropriately in-game.
@export var scale : float

## Holds the asteroid mesh instance
@export var asteroid_mesh : Mesh
