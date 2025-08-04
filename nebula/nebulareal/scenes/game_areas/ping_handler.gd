extends Control

var last_ping_sent_time = 0
var ping = 0
var connected = false

func _ready() -> void:
	multiplayer.connected_to_server.connect(OnConnected)

func OnConnected():
	connected = true

func _process(delta):
	if connected:
		# (Send dummy ping packet if needed, e.g., every few seconds)
		if multiplayer.is_server():
			# (Server logic to respond to ping requests)
			pass # Handle incoming ping requests and send responses
		else:
			# (Client logic to send ping requests and update UI)
			if Time.get_ticks_msec() - last_ping_sent_time > 1000: # Send ping every 1 second
				last_ping_sent_time = Time.get_ticks_msec()
				rpc_id(1, "send_ping", multiplayer.get_unique_id(), last_ping_sent_time) # Assuming server is peer_id 1

@rpc("reliable", "any_peer") # RPC for server to receive and respond to pings
func send_ping(caller_id, timestamp):
	if multiplayer.is_server():
		rpc_id(caller_id, "receive_pong", timestamp)

@rpc("reliable", "any_peer") # RPC for client to receive pong and calculate ping
func receive_pong(timestamp):
	if not multiplayer.is_server():
		ping = Time.get_ticks_msec() - timestamp
		%PingLabel.text = "Ping: " + str(ping) + "ms"
