extends Resource
class_name ScannerType

## Holds the name of the scanner type.
@export var name : String

## Holds the range of the scanner. 
@export var scanner_range : int

## Holds the maximum zoom that the camera can zoom out to. Different scanners will dictate how much zoom the camera can zoom out to.
@export var zoom_max : int
