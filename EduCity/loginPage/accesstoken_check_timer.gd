extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.wait_time = 60
	self.connect("timeout", _on_Timer_timeout)
	HttpLayer.connect("http_completed", http_completed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_Timer_timeout():
	if get_tree().current_scene.name == "LogSignScene":
		return 
	#check token remaining time
	#apply a new token if interval less than 60 sec
	var cur_time:int = Time.get_unix_time_from_system() 
	var ddl_time:int = GameManager.user_accessTokenDdl
	var time_diff:int = ddl_time - cur_time
	if time_diff > 60:
		print("token valid, no need to reply!")
		return
	else:
		HttpLayer._getNewAccessToken({
			"refreshToken": GameManager.user_refreshToken
		})
		

func http_completed(res, response_code, headers, route) -> void:
	#print(res)
	if response_code == 200 && route == "refresh-access-token":
		if res.code == 0000:
			print("applied success!")
			print("New token is " + res.data)
			GameManager.user_accessToken = res.data
			GameManager.user_accessTokenDdl = int(Time.get_unix_time_from_system() + GameManager.user_tokenValidityPeriod*60)
		else:
			AlertPopup.setPosition(0,0,'center')
			AlertPopup.show_error_message(res.data)
			get_tree().change_scene_to_file("res://loginPage/login.tscn")
			self.stop()
	
