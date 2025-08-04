extends Node

const WAYPOINT_PLACEMENT_RANGE = 500

func CheckWaypointPlacement(ship_pos, waypoint_pos):
	if HelperFunctions.GetDistanceBetweenTwoPoints(ship_pos, waypoint_pos) > WAYPOINT_PLACEMENT_RANGE:
		return false
	return true
