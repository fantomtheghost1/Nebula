extends Resource
class_name ShipType

## Holds the name of the ship type.
@export var name : String

## Holds the resource for this ship's engine.
@export var engine : EngineType

## Holds the resource for this ship's shield generator.
@export var shield_generator : ShieldGeneratorType

## Holds the resource for this ship's armor.
@export var armor : ArmorType

## Holds the resource for this ship's generator.
@export var generator : GeneratorType

## Holds the resource for this ship's cargo bay.
@export var cargo_bay : CargoType

## Holds the resource for this ship's scanner.
@export var scanner : ScannerType

## Holds the resource for this ship's chassis.
@export var chassis : ChassisType

## Holds the resource for this ship's mining turrets.
@export var mining_turret : MiningTurretType

## Holds the resource for this ship's mining turrets.
@export var combat_turret : CombatTurretType

## Holds the amount of turret slots that are available on this ship.
@export var turret_slots : int
