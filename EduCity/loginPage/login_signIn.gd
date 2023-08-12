extends Control

enum panels {log, sign1, sign2}

var currentPanel
#user info
var user_activeCode
#tabars
var logButton 
var signButton
#panels
var logPanel
var signPanel1
var signPanel2

#sign1 panel nodes
var emailSign
var activeCode
var getActiveCodeButton
var nextButton

#sign2 panel nodes
var completeButton
var resetButton
var usernameSign
var password1Sign
var password2Sign

var validEmailLabel_Log
var invalidEmailLabel_Log
var validEmailLabel_Sign
var invalidEmailLabel_Sign
var validPw1Label
var invalidPw1Label
var validPw2Label
var invalidPw2Label

#log panel nodes
var emailLog
var passwordLog
var loginButton

#others
var alertPopup

#timer
var countdown_sec = 60
var timer


# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.connect("http_completed", http_completed)
	initiate_variables()
	connect_signals()
	create_labels()
	set_focus()
	
	
	
func initiate_variables():
	currentPanel = panels.log
	#get node from whole panels
	logButton = get_node("Tabars/HBoxContainer/Log in")
	signButton = get_node("Tabars/HBoxContainer/Sign in")
	logPanel = get_node("log_in")
	signPanel1 = get_node("sign_in1")
	signPanel2 = get_node("sign_in2")
	
	#get node from sign_in1_panel
	emailSign = get_node("sign_in1/email_input_panel/LineEdit")
	activeCode = get_node("sign_in1/vcode_input_panel/LineEdit")
	getActiveCodeButton = get_node("sign_in1/get_activecode_button")
	nextButton = get_node("sign_in1/next_button_panel/next_button")
	
	#get node from sign_in2_panel
	usernameSign = get_node("sign_in2/username_panel/LineEdit")
	password1Sign =get_node("sign_in2/pw_input1_panel/LineEdit")
	password2Sign = get_node("sign_in2/pw_input2_panel/LineEdit")
	resetButton = get_node("sign_in2/sign_in2_button_panel/reset_button")
	completeButton = get_node("sign_in2/sign_in2_button_panel/complete_button")
	
	#get node from log_in_panel
	emailLog = get_node("log_in/email_input_panel/LineEdit")
	passwordLog = get_node("log_in/pw_input_panel/LineEdit")
	loginButton = get_node("log_in/login_button_panel/Login_button")
	
	#get node from other items
	alertPopup = get_node("AlertPopup")
	
	#timer
	timer = get_node("ActiveCodeTimer")
	timer.connect("timeout", _on_timer_timeout)
	
func connect_signals():
	#sign signals
	emailSign.connect("text_changed",  _on_email_line_edit_text_sign_changed)
	password1Sign.connect("text_changed",  _on_password_line_edit_text_changed)
	password2Sign.connect("text_changed",  _on_password_line_edit_text_changed)
	#log signals
	emailLog.connect("text_changed",  _on_email_line_edit_text_log_changed)


func set_focus():
	if currentPanel == panels.log:
		emailLog.grab_focus()
	
	
func create_labels():
	#creat valid verification labels
	validEmailLabel_Log = createLabel("Valid format!", Vector2(70, 205), 20, Color(0.0, 0.67, 0.0),logPanel)
	invalidEmailLabel_Log = createLabel("Invalid format!", Vector2(70, 205), 20, Color(0.78, 0.19, 0.24),logPanel)
	validEmailLabel_Log.visible = false
	invalidEmailLabel_Log.visible = false
	
	validEmailLabel_Sign = createLabel("Valid format!", Vector2(70, 193), 20, Color(0.0, 0.67, 0.0),signPanel1)
	invalidEmailLabel_Sign = createLabel("Invalid format!", Vector2(70, 193), 20, Color(0.78, 0.19, 0.24),signPanel1)
	validEmailLabel_Sign.visible = false
	invalidEmailLabel_Sign.visible = false
	
	validPw1Label = createLabel("Passwords match!", Vector2(70, 255), 20, Color(0.0, 0.67, 0.0),signPanel2)
	invalidPw1Label = createLabel("Passwords do not match!", Vector2(70, 255), 20, Color(0.78, 0.19, 0.24),signPanel2)
	validPw1Label.visible = false
	invalidPw1Label.visible = false
	
	validPw2Label = createLabel("Passwords match!", Vector2(70, 350), 20, Color(0.0, 0.67, 0.0),signPanel2)
	invalidPw2Label = createLabel("Passwords do not match!", Vector2(70, 350), 20, Color(0.78, 0.19, 0.24),signPanel2)
	validPw2Label.visible = false
	invalidPw2Label.visible = false

func _on_eye_hide_toggled(button_pressed):
	changePasswordHideState(password1Sign)

func _on_eye_hide_2_toggled(button_pressed):
	changePasswordHideState(password2Sign)

func _on_eye_hide_3_toggled(button_pressed):
	changePasswordHideState(passwordLog)
	
func changePasswordHideState(passwordNode: Node):
	passwordNode.set_secret(!passwordNode.secret)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !checkEmailFormat(emailLog.text) || emailLog.text == "" || passwordLog.text == "":
		loginButton.disabled = true;
	else:
		loginButton.disabled = false;
	if !checkEmailFormat(emailSign.text) || emailSign.text == "" || activeCode.text == "":
		nextButton.disabled = true;
	else:
		nextButton.disabled = false;
	if usernameSign.text == "" || password1Sign.text == "" || password2Sign.text == "" || password1Sign.text != password2Sign.text:
		completeButton.disabled = true;
	else:
		completeButton.disabled = false;
	
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			if currentPanel == panels.log:
				if loginButton.disabled:
					passwordLog.grab_focus()
				else:
					loginButton.set_pressed(true)
					loginButton.grab_focus()
			if currentPanel == panels.sign1:
				if nextButton.disabled:
					activeCode.grab_focus()
				else:
					nextButton.set_pressed(true)
					nextButton.grab_focus()
			if currentPanel == panels.sign2:
				if completeButton.disabled:
					if password1Sign.has_focus():
						password2Sign.grab_focus()
					else:
						password1Sign.grab_focus()
				else:
					if resetButton.has_focus():
						resetButton.set_pressed
					else:
						completeButton.set_pressed(true)
						completeButton.grab_focus()

#******************************   User  Operations  ********************************#
func _on_log_in_pressed():
	currentPanel = panels.log
	emailLog.grab_focus()	
	logButton.set_pressed(true)
	signButton.set_pressed(false)
	logPanel.visible = true
	signPanel1.visible = false
	signPanel2.visible = false
	

func _on_sign_in_pressed():
	currentPanel = panels.sign1
	emailSign.grab_focus()	
	logButton.set_pressed(false)
	signButton.set_pressed(true)
	signPanel1.visible = true
	logPanel.visible = false

func _on_reset_button_pressed():
	usernameSign.text = ""
	password1Sign.text = ""
	password2Sign.text = ""
	validPw1Label.visible = false
	validPw2Label.visible = false
	


func _on_email_line_edit_text_log_changed(new_text):
	var isValid = checkEmailFormat(new_text)
	if emailLog.text == "":
		invalidEmailLabel_Log.visible = false
		validEmailLabel_Log.visible = false
	elif isValid:
		invalidEmailLabel_Log.visible = false
		validEmailLabel_Log.visible = true
	else:
		invalidEmailLabel_Log.visible = true
		validEmailLabel_Log.visible = false
	
	
func _on_email_line_edit_text_sign_changed(new_text):
	var isValid = checkEmailFormat(new_text)
	if emailSign.text == "":
		invalidEmailLabel_Sign.visible = false
		validEmailLabel_Sign.visible = false
	elif isValid:
		invalidEmailLabel_Sign.visible = false
		validEmailLabel_Sign.visible = true
	else:
		invalidEmailLabel_Sign.visible = true
		validEmailLabel_Sign.visible = false


func _on_password_line_edit_text_changed(new_text):
	if password1Sign.text != "" && password2Sign.text != "":
		if password1Sign.text == password2Sign.text:
			validPw1Label.visible = true
			validPw2Label.visible = true
			invalidPw1Label.visible = false
			invalidPw2Label.visible = false			
		else:
			validPw1Label.visible = false
			validPw2Label.visible = false
			invalidPw1Label.visible = true
			invalidPw2Label.visible = true
	else:
		validPw1Label.visible = false
		validPw2Label.visible = false
		invalidPw1Label.visible = false
		invalidPw2Label.visible = false
		
		
func checkEmailFormat(new_text):
	var emailPattern = "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b"  # 定义电子邮件的正则表达式模式
	var regex = RegEx.new()
	regex.compile(emailPattern)  # 编译正则表达式
	return regex.search(new_text) != null  # 检查邮箱是否与模式匹配
	
	
func createLabel(text: String, position: Vector2, fontSize: int, textColor: Color, parent: Node):
	var tagLabel = Label.new()
	tagLabel.text = text
	tagLabel.position = position
	tagLabel.add_theme_font_size_override("font_size", fontSize)
	tagLabel.modulate =  textColor
	tagLabel.visible = true
	
	parent.add_child(tagLabel)
	return tagLabel


func _on_next_button_pressed():
	if activeCode.text != user_activeCode:
		setAlert("Active code is not correct, please try again!")
		return
	currentPanel = panels.sign2
	usernameSign.grab_focus()
	signPanel1.visible = false
	signPanel2.visible = true
	

func _on_login_button_pressed():
	login(emailLog.text, passwordLog.text);
	ActiveStatusCheckTimer.startTimer()


func _on_complete_button_pressed():
	register(emailSign.text, activeCode.text, usernameSign.text, password1Sign.text);

func _on_get_activecode_button_pressed():
	if !checkEmailFormat(emailSign.text) || emailSign.text == "":
		AlertPopup.setPosition(0,0,'login')
		AlertPopup.show_error_message("   Invalid email format. \n   Please check again!")
	else:
		getActiveCodeButton.disabled = true
		start_countdown()
		checkEmailIsExisted(emailSign.text)
	

#******************************   Send Request to Back End  ********************************#
func checkEmailIsExisted(email:String):
	var _credential = {
			"email": email,
	}
	HttpLayer._checkEmailIsExisted(_credential)
	
func getActiveCode():
	var email = emailSign.text
	var _credential = {
			"email": email,
	}
	HttpLayer._getActiveCode(_credential)
	

func login(email:String, password:String):
	var _credential = {
			"email": email,
			"password": password,
	}
	HttpLayer._login(_credential);


func register(email: String, activeCode:String, username:String, password:String):
	var _credential = {
			"email": email,
			"activecode": activeCode,
			"isFirst":1,
			"name": username,
			"password": password
	}
	HttpLayer._register(_credential)
	
func _get_localStorage():
	HttpLayer._getStatus({
		"id": GameManager.user_id
	})

	
func _http_ClearMapTime(cellPos, houseType):
	var _credential = {
		"x": cellPos.x,
		"y": cellPos.y,
		"houseType": houseType,
		"id": GameManager.user_id,
	}
	HttpLayer._clearMapTime(_credential)

#******************************   Handle The Response Data From The Backend  ********************************#
func http_completed(res, response_code, headers, route) -> void:
	#print(res)
	if response_code == 200 && route == "login":
		#save id to user_id in GameManager
		if !res.code == 0000:
			AlertPopup.setPosition(0,0,'login')
			AlertPopup.show_error_message(res['data'])
		else:	
			initializeGameManager(res)
			print(GameManager.user_data)
			print("------------------------login success!")
			$LoginLoadingScene.visible = true
			# When login is !successful!, get the required data from the database to localStorage
			# get current user's learning status and save in localStorage
			if GameManager.user_id != null:
				HttpLayer._getComponents()
				HttpLayer._readMap()
				_get_localStorage()
		return
	if response_code == 200 && route == "register":
		#if(res.code == 0000):
		AlertPopup.setPosition(0,0,'login')
		AlertPopup.show_error_message(res['data'])
		print("------------------------resgister success!")
		return	
	if response_code == 200 && route == "email":
		if res['code'] == 4001:
			getActiveCode()
		else:
			AlertPopup.setPosition(0,0,'login')
			AlertPopup.show_error_message(res['data'])
		return
	if response_code == 200 && route == "active":
		#email sent success
		if res['code'] == 4002:
			AlertPopup.setPosition(0,0,'login')
			AlertPopup.show_error_message(res['msg'])
			user_activeCode = res['data']
		else:
			AlertPopup.setPosition(0,0,'login')
			AlertPopup.show_error_message("       Failed to send email because of error unkwon./n      Please try again later!")
		return
	#if token is checked and valid, return true
	if !AlertPopup.tokenCheck(res):
		return	
	if response_code == 200 && route == "refresh-access-token":
		GameManager.user_accessToken = res.data
		return
	if response_code == 200 && route == "readMap":
		for i in range(0, res.num):
			var cellPos_temp
			cellPos_temp = position
			cellPos_temp.x = res.x[i]
			cellPos_temp.y = res.y[i]
			# If build is finish, change finish_time to 0 in mapDict
			var nowTimestamp:int = Time.get_unix_time_from_system()
			if res.finishTime[i] != 0 and res.finishTime[i] <= nowTimestamp:
				GameManager.mapDict[Vector2i(cellPos_temp)] = {"house_type":res.houseType[i], "finish_time":0}
				_http_ClearMapTime(cellPos_temp,res.houseType[i])
				#var prosperity = GameManager.buildings_data[selectedBuildingType].prosperity
				var building_data = getBuildingDataByID(res.houseType[i])
				var cost = building_data["cost"]
				var prosperity = building_data["prosperity"]
				GameManager.prosperity += prosperity

				if res.houseType[i] == GameManager.BuildingType.constrction_site_1 or\
				res.houseType[i] == GameManager.BuildingType.constrction_site_2 or\
				res.houseType[i] == GameManager.BuildingType.constrction_site_3:
					if GameManager.construction_speed < 6:
						GameManager.construction_speed += 1
			
				var _credential = {
					"gold": GameManager.gold,
					"prosperity": GameManager.prosperity,
					"construction_speed": GameManager.construction_speed,
					"id": GameManager.user_id,
				}
				HttpLayer._pushComponents(_credential);
				
			else:
				GameManager.mapDict[Vector2i(cellPos_temp)] = {"house_type":res.houseType[i], "finish_time":res.finishTime[i]}
		print("---------------------read map success!")
		return
	if response_code == 200 && route == "getComponents":
		GameManager.gold = res.gold
		GameManager.prosperity = res.prosperity
		GameManager.construction_speed = res.construction_speed
		GameManager.population = GameManager.gold + GameManager.prosperity + GameManager.construction_speed
		GameManager.gold_get_time = res.gold_get_time
		return
	if response_code == 200 && route == "clearMapTime":
		print("成功更新后端")
	if response_code == 200 && route == "status":
		# save data to knowledge status list in GameManager
		for i in res['statusList'].size():
			GameManager.statusList[i] = res['statusList'][i]	
		# save data to quiz status list in GameManager	
		for i in res['completeList'].size():
			GameManager.quizStatus.append(res['completeList'][i])	
		print("---------------------get status success!")
		# wait 0.5 second and change to main_sence
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://main_scene.tscn")
		return

func initializeGameManager(res) :
	GameManager.user_data = {
				"id" : res.data.id,
				"email" : res.data.email,
				"name" : res.data.name,
				"avatarStr" : res.data.avatarStr,
				"cityMap" : res.data.cityMap,
				"logoutTime" : res.data.logoutTime,
				"accessToken" : res.data.accessToken,
				"refreshToken" : res.data.refreshToken,
				"isFirst" : res.data.isFirst,
				"tokenValidityPeriod" : res.data.tokenValidityPeriod
			}
	GameManager.user_id = GameManager.user_data['id']
	GameManager.user_isFirst = GameManager.user_data['isFirst']
	GameManager.user_accessToken = GameManager.user_data['accessToken']
	GameManager.user_refreshToken = GameManager.user_data['refreshToken']
	GameManager.user_lastActiveTime = int(Time.get_unix_time_from_system())
	GameManager.user_tokenValidityPeriod = GameManager.user_data['tokenValidityPeriod']
	GameManager.user_accessTokenDdl = int(Time.get_unix_time_from_system() + GameManager.user_tokenValidityPeriod*60)
	AccesstokenCheckTimer.start()

func setAlert(msg:String):
	alertPopup.set_text(msg)
	alertPopup.visible = true;
	

#******************************   Timer Set  ********************************#
func start_countdown():
	timer.start(1.0)
	countdown_sec = 60
	update_button_text()
	

func _on_timer_timeout():
	countdown_sec -= 1
	update_button_text()

	if countdown_sec <= 0:
		timer.stop()
		getActiveCodeButton.disabled = false

func update_button_text():
	if countdown_sec > 0:
		getActiveCodeButton.text = "Get new after " + str(countdown_sec) + " sec"
	else:
		getActiveCodeButton.text = "Get Active Code"

func getBuildingDataByID(id:int) -> Dictionary:
	for building_data in GameManager.buildings_data:
		if building_data["tileID"] == id:
			return building_data
	return {}
