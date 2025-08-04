extends HTTPRequest

var main_menu: Control
var json = JSON.new()
var server_api = "http://172.233.131.183:80"
var headers = ["Content-Type: application/json"]
var current_server_browser_instance: Control = null
var current_request_type = ""

func _ready():
	GlobalVariables.server_browser_http = self

func GetQuickPlayServer():
	if current_request_type != "":
		push_warning("Another request is in progress: ", current_request_type)
		return
	current_request_type = "get_quickplay"
	cancel_request()
	if not request_completed.is_connected(_on_get_quickplay_server_request_completed):
		request_completed.connect(_on_get_quickplay_server_request_completed)
	request(server_api + "/get_quickplay_server", headers, HTTPClient.METHOD_GET)

func GetServers():
	if current_request_type != "":
		push_warning("Another request is in progress: ", current_request_type)
		return
	current_request_type = "get_servers"
	cancel_request()
	if not request_completed.is_connected(_on_get_servers_request_completed):
		request_completed.connect(_on_get_servers_request_completed)
	request(server_api + "/get_servers", headers, HTTPClient.METHOD_GET)

func AddServer(server_name: String, server_port: String, server_password: String, player_count_max: int, server_ip: String):
	if current_request_type != "":
		push_warning("Another request is in progress: ", current_request_type)
		return
	current_request_type = "add_server"
	cancel_request()
	var body_data = {
		"server_ip" : server_ip,
		"server_port" : int(server_port),
		"server_name" : server_name,
		"server_password" : server_password,
		"player_count_limit" : player_count_max
	}
	var json_body = JSON.stringify(body_data)
	request("%s/add_server" % server_api, headers, HTTPClient.METHOD_POST, json_body)
	current_request_type = ""

func RemoveServer(server_ip: String):
	if current_request_type != "":
		push_warning("Another request is in progress: ", current_request_type)
		return
	current_request_type = "remove_server"
	cancel_request()
	var url = "%s/remove_server?server_ip=%s" % [server_api, server_ip]
	request(url, headers, HTTPClient.METHOD_POST)
	
func PingAPI(server_ip: String):
	if current_request_type != "":
		push_warning("Another request is in progress: ", current_request_type)
		return
	current_request_type = "ping_api"
	cancel_request()
	var url = "%s/ping_api?server_ip=%s" % [server_api, server_ip]
	request(url, headers, HTTPClient.METHOD_POST)
	current_request_type = ""

func CanJoin(server_ip: String, password: String, server_browser_instance: Control):
	if current_request_type != "":
		push_warning("Another request is in progress: ", current_request_type)
		return
	current_request_type = "can_join"
	cancel_request()
	current_server_browser_instance = server_browser_instance
	if not request_completed.is_connected(_on_can_join_request_completed):
		request_completed.connect(_on_can_join_request_completed)
	var url = "%s/can_join?server_ip=%s&password=%s" % [server_api, server_ip, password]
	request(url, headers, HTTPClient.METHOD_GET)
	
func SetPlayerCount(server_ip: String, player_count: int):
	if current_request_type != "":
		push_warning("Another request is in progress: ", current_request_type)
		return
	current_request_type = "set_player_count"
	cancel_request()
	var body_data = {
		"server_ip" : server_ip,
		"player_count" : player_count
	}
	var json_body = JSON.stringify(body_data)
	request("%s/set_server_player_count" % server_api, headers, HTTPClient.METHOD_POST, json_body)
	current_request_type = ""

func _on_can_join_request_completed(result, response_code, _headers, body):
	if current_request_type != "can_join":
		push_warning("Received response for unexpected request type: ", current_request_type)
		return
	current_request_type = ""
	if request_completed.is_connected(_on_can_join_request_completed):
		request_completed.disconnect(_on_can_join_request_completed)
	if result != OK or response_code != 200:
		push_error("Error: HTTP request failed, result: ", result, ", response_code: ", response_code)
		if current_server_browser_instance != null:
			push_error("Server request failed")
		return
	var parse_result = json.parse(body.get_string_from_utf8())
	if parse_result != OK or json.data == null:
		push_error("Error: Failed to parse JSON response, error code: ", parse_result)
		if current_server_browser_instance != null:
			push_error("Invalid server response")
		return
	if json.data is Array:
		push_error("Error: Received unexpected array response for can_join")
		if current_server_browser_instance != null:
			push_error("Unexpected server response")
		return
	if current_server_browser_instance != null:
		current_server_browser_instance.HandleResponse(json.data)
	else:
		push_error("Error: current_server_browser_instance is null")

func _on_get_quickplay_server_request_completed(result, response_code, _headers, body):
	if current_request_type != "get_quickplay":
		push_warning("Received response for unexpected request type: ", current_request_type)
		return
	current_request_type = ""
	if request_completed.is_connected(_on_get_quickplay_server_request_completed):
		request_completed.disconnect(_on_get_quickplay_server_request_completed)
	if result != OK or response_code != 200:
		push_error("Error: HTTP request failed, result: ", result, ", response_code: ", response_code)
		return
	var parse_result = json.parse(body.get_string_from_utf8())
	if parse_result != OK or json.data == null:
		push_error("Error: Failed to parse JSON response, error code: ", parse_result)
		return
	main_menu.HandleQuickPlayResponse(json.data)

func _on_get_servers_request_completed(result, response_code, _headers, body):
	if current_request_type != "get_servers":
		push_warning("Received response for unexpected request type: ", current_request_type)
		return
	current_request_type = ""
	if request_completed.is_connected(_on_get_servers_request_completed):
		request_completed.disconnect(_on_get_servers_request_completed)
	if result != OK or response_code != 200:
		push_error("Error: HTTP request failed, result: ", result, ", response_code: ", response_code)
		return
	var parse_result = json.parse(body.get_string_from_utf8())
	if parse_result != OK or json.data == null:
		push_error("Error: Failed to parse JSON response, error code: ", parse_result)
		return
	%ServerContainer.ClearServers()
	for server in json.data:
		if server == null:
			continue
		server["server_name"] = server["server_name"].replace("_", " ")
		%ServerContainer.AddServer(server)
