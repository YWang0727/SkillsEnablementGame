extends Control

var profile_scene: String = "res://setting/src/account/profile.tscn"
var HttpLayer_Account = preload("res://setting/src/account/HttpLayer_Account.gd")

var account_API

var alert: Popup
var uploadFileButton: Button
var fileUploadWindow: FileDialog
var backButton: Button
var profileSave: Button
var passwordSave: Button
var profileCancel: Button
var passwordCancel: Button

var username: LineEdit
var email: LineEdit
var avatar: TextureRect
var uploadedFile: PackedByteArray
var oldPassword: LineEdit
var newPassword: LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	initiate_variales()
	connect_signals()
	
	HttpLayer.http_completed.connect(http_completed)
	
	# fetched user basic infomation from server
	account_API.fetch_user_info(GameManager.user_id)

func initiate_variales():
	account_API = HttpLayer_Account.new()
	
	alert = get_node("Alert")
	uploadFileButton = get_node("Edit/VBoxContainer/Avatar/HBoxContainer/Upload/UploadButton")
	fileUploadWindow = get_node("FileUploadWindow")
	backButton = get_node("BackButton")
	profileSave = get_node("Edit/VBoxContainer/ProfileButtons/Save")
	passwordSave = get_node("Edit/VBoxContainer/PasswordButtons/Save")
	profileCancel = get_node("Edit/VBoxContainer/ProfileButtons/Cancel")
	passwordCancel = get_node("Edit/VBoxContainer/PasswordButtons/Cancel")
	
	username = get_node("Edit/VBoxContainer/Username/LineEdit")
	email = get_node("Edit/VBoxContainer/Email/LineEdit")
	avatar = get_node("Edit/VBoxContainer/Avatar/HBoxContainer/DisplayAvatar")
	oldPassword = get_node("Edit/VBoxContainer/OldPassword/LineEdit")
	newPassword = get_node("Edit/VBoxContainer/NewPassword/LineEdit")

# connect signals and functions
func connect_signals():
	uploadFileButton.pressed.connect(_on_fileupload_button_pressed)
	fileUploadWindow.file_selected.connect(_on_file_upload_window_file_selected)
	backButton.pressed.connect(_on_back_button_pressed)
	
	# Confirm Buttons
	profileSave.pressed.connect(edit_user_profile)
	passwordSave.pressed.connect(edit_user_password)
	profileCancel.pressed.connect(_on_back_button_pressed)
	passwordCancel.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed():
	get_tree().change_scene_to_file(profile_scene)



# display the window for uploading file when pressing button upload
func _on_fileupload_button_pressed():
	fileUploadWindow.add_filter("*.png, *.jpg", "Images");
	fileUploadWindow.popup_centered()

# process uploaded avatar image
func _on_file_upload_window_file_selected(path: String):
	var fileData = FileAccess.get_file_as_bytes(path)
	# check if file size is valid (less than 64KB)
	if (fileData.size() > 65536):
		alert.set_message("Please keep avatar size in 64KB!")
		alert.popup_centered()
		return
	
	# show new avatar in game
	var avatarImage = Image.new()
	avatarImage.load(path)
	var texture = ImageTexture.create_from_image(avatarImage)
	avatar.texture = texture
	# store file data in global variable
	uploadedFile = fileData


# connected with edit_profile button
# send saving profile request to server
func edit_user_profile():
	if (!checkUsernameFormat(username.text)):
		alert.set_message("Username is invalid")
		alert.popup_centered()
		return
	if (!checkEmailFormat(email.text)):
		alert.set_message("Email is invalid")
		alert.popup_centered()
		return
			
	var httpRequest = HTTPRequest.new()
	add_child(httpRequest)
	httpRequest.request_completed.connect(self.edit_user_profile_request_completed.bind(httpRequest))
	
	var url = "http://localhost:8080/setting/editUserInfo"
	var headers = PackedStringArray(["Content-Type: multipart/form-data; boundary=MyBoundary"])
	headers.append(str("Authorization: Bearer ", GameManager.user_token))
	
	# create the body of editing user info request
	# use from to send request, first part is the json data, second is the picture byte data
	var body = PackedByteArray()
	body.append_array("--MyBoundary\r\n".to_utf8_buffer())
	body.append_array("Content-Disposition: form-data; name=\"json\"\r\n".to_utf8_buffer())
	body.append_array("Content-Type: application/json\r\n".to_utf8_buffer())
	body.append_array("\r\n".to_utf8_buffer())
	var json = JSON.stringify({
		"id": GameManager.user_id,
		"name": username.text,
		"email": email.text
	})
	body.append_array(json.to_utf8_buffer())
	body.append_array("\r\n".to_utf8_buffer())
	
	body.append_array("--MyBoundary\r\n".to_utf8_buffer())
	body.append_array("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n".to_utf8_buffer())
	body.append_array("Content-Type: image/jpg\r\n".to_utf8_buffer())
	body.append_array("\r\n".to_utf8_buffer())
	body.append_array(uploadedFile)
	body.append_array("\r\n".to_utf8_buffer())
	body.append_array("--MyBoundary--".to_utf8_buffer())
	
	httpRequest.request_raw(url, headers, HTTPClient.METHOD_PUT, body)

func edit_user_profile_request_completed(result, response_code, headers, body, httpRequest: HTTPRequest):
	# parse response json
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	if (response_code == 200):
		print(response.msg)
		# check if code in resultVO is 0000(SUCCESS)
		if (response.code != 0):
			alert.set_message(response.data)
			alert.popup_centered()
			return
			
		print(response.data)
	else:
		print(response_code)
		print("Unkown Error when editing profile")
		
	HttpLayer._destroyHttpObject(httpRequest)


# send editing password request to server
func edit_user_password():
	if (!checkPasswordFormat(oldPassword.text) || !checkPasswordFormat(newPassword.text)):
		alert.set_message("Password is invalid")
		alert.popup_centered()
		return
		
	account_API.edit_user_password({
		"id": GameManager.user_id,
		"oldPassword": oldPassword.text,
		"newPassword": newPassword.text
	})

# return true if password format is valid
func checkPasswordFormat(password: String) -> bool:
	if (password == null):
		return false
	if (password.length() > 20 || password.length() < 4):
		return false
	return true

# return true if username format is valid
func checkUsernameFormat(str: String) -> bool:
	if (str == null):
		return false
	if (str.length() > 20 || str.length() < 1):
		return false
	return true

# check if email format is valid
func checkEmailFormat(str: String) -> bool:
	if (str == null):
		return false
	if (str.length() > 20 || str.length() < 8):
		return false
		
	var emailPattern = "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b"
	var regex = RegEx.new()
	regex.compile(emailPattern)
	return regex.search(str) != null

# callback function of http request
func http_completed(res, response_code, headers, route):
	if (response_code == 200):
		print(res.msg)
		# check if code in resultVO is 0000(SUCCESS)
		if (res.code != 0):
			if (route == "editPassword"):
				alert.set_message(res.data)
				alert.popup_centered()
				return
				
		if (route == "getUserInfo"):
			display_user_info(res.data)
		elif (route == "editPassword"):
			print(res.data)
			
	else:
		if (route == "getUserInfo"):
			print("Fail to get user's data")
		elif (route == "editPassword"):
			print("Fail to change password")


# diaplay user infomation as default text in line editor
func display_user_info(data):
	username.text = data.name
	email.text = data.email
	
	# display byte data of avatar
	var avatarStr = data.avatarStr
	if (avatarStr != null && avatarStr != ""):
		display_user_avatar(avatarStr)

# decode avatar data stored in string and display it
func display_user_avatar(avatarStr: String):
	# decode string to byte
	var avatarData = Marshalls.base64_to_raw(avatarStr)
	
	var image = Image.new()
	var isJPG = check_image_format(avatarData)
	if (isJPG):
		image.load_jpg_from_buffer(avatarData)
	else :
		image.load_png_from_buffer(avatarData)
		
	var image_texture = ImageTexture.create_from_image(image)
	avatar.texture = image_texture

# return true if image is in jpg format, false if in png
func check_image_format(imageData: PackedByteArray) -> bool:
	var signature = imageData.slice(0, 4)
	if (signature == PackedByteArray([0xFF, 0xD8, 0xFF, 0xE0])):
		return true
	return false
