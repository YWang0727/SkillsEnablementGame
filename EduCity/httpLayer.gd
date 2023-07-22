extends CanvasLayer

# set endpoint
var endpoint_api = "http://localhost:8080/"

var use_threads = false

signal http_completed(res, response_code, headers, route)

# Callback function after completion of HTTP request
func _on_HTTPRequest_request_completed(result, response_code, headers, body, route, httpObject, redirectTo = null):
	# Converts the response body to a JSON object and stores the result
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var res = json.get_data()
	print(response_code)
	print(res)
	
	emit_signal("http_completed", res, response_code, headers, route)
		
	if res != null && res.has("status"):
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
						print("token" + GameManager.user_token)
						GameManager.user_data = res['data']['user']
						GameManager.save_data = GameManager.user_data['save_data']

					"register":
						GameManager.save_data = GameManager.user_data['save_data']
				
	if redirectTo != null && redirectTo != "no":
		var _changeScene = get_tree().change_scene_to_file(redirectTo)
		
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
func _apiCore(_endpoint, _data, _authorize, _method: String, _route , _redirectTo = null ):
	# Create a new instance of HTTPRequest and connect it to the signal request_completed to trigger the specified callback function _on_HTTPRequest_request_completed when the request completes.
	var http = HTTPRequest.new()
	add_child(http)
	http.use_threads = use_threads
	
	# Create a list containing request headers
	var headers = [
		"Content-Type: application/json",
		"Accept: application/json",
		]
	
	# If _authorize is true, add the "Authorization" header to the headers list and use Game.user_token for authorization
	if _authorize:
		headers.append(str("Authorization: Bearer ", GameManager.user_token))
		
	#print("api success")
		
	# Loading progress scene
	#Loader.prog = http
	
	var http_error = 1
	# don't send body if we are using get method
	if (_method == "GET"):
		http_error = http.request(str(endpoint_api, _endpoint), headers, HTTPClient.METHOD_GET)
	else:
		http_error = http.request(str(endpoint_api, _endpoint), headers, HTTPClient[str("METHOD_",_method)], JSON.new().stringify(_data))
	if http_error != OK:
		print(http_error)
	#	Loader.prog = null
	#	Loader.close()
	
	http.request_completed.connect(_on_HTTPRequest_request_completed.bind(_route, http, _redirectTo))


# Call the _apiCore function to send the corresponding API request

#api for log in and sign up
func _login(_credentials):
	_apiCore("auth/login", _credentials, false, "POST", "login")
	
func _register(_credentials):
	_apiCore("auth/register", _credentials, false, "POST", "register")

func _checkEmailIsExisted(_credentials):
	_apiCore("user/email", _credentials, false, "POST", "email")

func _getActiveCode(_credentials):
	_apiCore("user/email", _credentials, false, "POST", "email")
	
# api for learning_related scene	
func _completeLesson(_credentials):
	_apiCore("learn/complete", _credentials, false, "POST", "complete")

func _submitQuiz(_credentials):
	_apiCore("learn/submit", _credentials, false, "POST", "submit")
	
func _getStatus(_credentials):
	_apiCore("learn/status", _credentials, false, "POST", "status")
	
func _leaderBoard():
	_apiCore("map/leaderBoard/" + str(GameManager.user_id), null, false, "GET", "leaderBoard")

func _getComponents():
	_apiCore("map/getComponents/" + str(GameManager.user_id), null, false, "GET", "getComponents")
	
func _pushComponents(_credentials):
	_apiCore("map/pushComponents", _credentials, false, "POST", "pushComponents")
	
func _readMap():
	_apiCore("map_cell/readMap/" + str(GameManager.user_id), null, false, "GET", "readMap")
	
func _buildHouse(_credentials):
	_apiCore("map_cell/buildHouse", _credentials, false, "POST", "buildHouse")


