extends Resource
class_name StarbaseType

@export var starbase_type : String
@export var level : int
@export var hp : int

## Holds the resource for this starbase's shield generator.
@export var shield_generator : ShieldGeneratorType

## Holds the resource for this starbase's armor.
@export var armor : ArmorType

## Holds the resource for this starbase's generator.
@export var generator : GeneratorType

## Holds the resource for this starbase's cargo bay.
@export var cargo_bay : CargoType

## Holds the resource for this starbase's scanner.
@export var scanner : ScannerType

## Holds the enabled services for this starbase.
@export var services : Dictionary

## Holds the amount of turret slots that are available on this starbase.
@export var turret_slots : int
