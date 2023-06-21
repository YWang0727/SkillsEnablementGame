extends CanvasLayer

# set endpoint
var endpoint_api = "http://localhost:8080/api"

var use_threads = false

signal http_completed(res, response_code, headers, route)

# Callback function after completion of HTTP request
func _on_HTTPRequest_request_completed(result, response_code, headers, body, route, httpObject, redirectTo = null):
	# Converts the response body to a JSON object and stores the result
	var parser = JSON.new()
	var json = parser.parse(body.get_string_from_utf8())
	var res = json.result
	
	emit_signal("http_completed", res, response_code, headers, route)

	if res == null:
		print("API is not running")
		return
		
	if res.has("status"):
		
		match res.status:
			"error":
				var msg = res.message
				
				if TYPE_DICTIONARY == typeof(msg):
					msg = ""
					for k in res.message.keys():
						msg = str(msg, "\n - ", res.message[k][0])
				
				print(msg)
				_destroyHttpObject(httpObject)
				return
			
			"success":
				# Matching judgements based on different routes
				match route:
					
					"login":
						GameManager.user_token = res['data']['token']
						GameManager.user_data = res['data']['user']
						GameManager.save_data = GameManager.user_data['save_data']

					"register":
						GameManager.save_data = GameManager.user_data['save_data']
				
	if redirectTo != null && redirectTo != "no":
		var _changeScene = get_tree().change_scene_to(load(redirectTo))
		
	#Loader.prog = null
	#Loader.close()
	
	# remove http request
	_destroyHttpObject(httpObject)


# Used to destroy the HTTP request object, ensuring that the memory and resources used by the request are freed.
func _destroyHttpObject(_object):
	if weakref(_object).get_ref():
		_object.queue_free()


# The core operations used to make HTTP requests:
# _apiCore(Endpoint of the request (router), Data to be sent (request body), Whether authorisation is required, Methods of request (GET, POST, PUT, DELETE, etc.), Route info, Redirected info)
func _apiCore(_endpoint, _data, _authorize = false, _method="GET", _route = "", _redirectTo = null):
	# Create a new instance of HTTPRequest and connect it to the signal request_completed to trigger the specified callback function _on_HTTPRequest_request_completed when the request completes.
	var http = HTTPRequest.new()
	http.use_threads = use_threads
	http.request_completed.connect(_on_HTTPRequest_request_completed.bind(_route, http, _redirectTo))
	add_child(http)
	
	# Create a list containing request headers
	var headers = [
		"Content-Type: application/json",
		"Accept: application/json",
		]
	
	# If _authorize is true, add the "Authorization" header to the headers list and use Game.user_token for authorization
	if _authorize:
		headers.append(str("Authorization: Bearer ", GameManager.user_token))
		
	# Loading progress scene
	#Loader.prog = http
	
	#var http_error = http.request(str(endpoint_api, _endpoint), headers, false, HTTPClient[str("METHOD_",_method)], to_json(_data))
	#if http_error != OK:
	#	Loader.prog = null
	#	Loader.close()


# Call the _apiCore function to send the corresponding API request
func _login(_credentials, _redirectTo):
	_apiCore("login", _credentials, false, "POST", "login", _redirectTo)
	
func _register(_credentials, _redirectTo):
	_apiCore("register", _credentials, false, "POST", "register", _redirectTo)
