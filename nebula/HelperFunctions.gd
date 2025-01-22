extends Node

func GetEnumStringFromIndex(enum_param, index) -> String:
	var reversed = {}
	for key in enum_param:
		reversed[enum_param[key]] = key
	return reversed[index]
