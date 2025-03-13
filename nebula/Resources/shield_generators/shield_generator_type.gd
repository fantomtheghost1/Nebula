extends Resource
class_name ShieldGeneratorType

## Holds the name of the shield generator type.
@export var name : String

## Holds the max hp of the shield generator.
@export var max_hp : int

## Holds the max sp of the shield bubble.
@export var max_sp : int

## Holds the amount of time it takes before the recharge_amount of sp is recharged. Typically this number is very low.
@export var recharge_tick : float

## Holds the amount of delay before the shield bubble regenerates after taking damage.
@export var recharge_delay : float

## Holds the amount of sp that gets recharged after the recharge_tick.
@export var recharge_amount : int
