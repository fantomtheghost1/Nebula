extends Node

var relays = []

func AddRelay(relay : Node3D) -> void:
	relays.append(relay)

func GetAllRelayData():
	var data_dict = {}
	var index = 0
	for relay in relays:
		if relay:
			var data = {
				"warp_pos": relay.warp_pos,
				"position": relay.position,
				"ship_container_path": relay.ship_container_path,
				"node_path": str(relay.get_path())
			}
			data_dict[index] = data
			index += 1
	return data_dict
