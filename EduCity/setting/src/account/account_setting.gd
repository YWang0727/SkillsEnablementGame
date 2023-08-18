extends CanvasLayer

var FileLoadCallback = JavaScriptBridge.create_callback(Callable(self, "js_file_uploaded"))

var alert: Popup
var uploadFileButton: Button
var fileUploadWindow: FileDialog
var closeButton: Button
var backButton: Button
var profileSave: Button
var passwordSave: Button
var profileCancel: Button
var passwordCancel: Button
var buttonSound: AudioStreamPlayer2D
var cancelSound: AudioStreamPlayer2D

var username: LineEdit
var email: LineEdit
var cityName: LineEdit
var cityNameTempValue: String
var avatar: TextureRect
var uploadedFile: PackedByteArray
var oldPassword: LineEdit
var newPassword: LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	initiate_variales()
	connect_signals()
	display_user_info(GameManager.user_data)
	cityName.text = GameManager.property_data.cityName
	
	if OS.get_name() == "Web":
		var window = JavaScriptBridge.get_interface("window")
		window.getImage(FileLoadCallback)

func _on_visibility_changed():
	if (visible):
		display_user_info(GameManager.user_data)
		cityName.text = GameManager.property_data.cityName

func initiate_variales():
	alert = get_node("Control/Alert")
	uploadFileButton = get_node("Control/Body/VBoxContainer/HBoxContainer/Avatar/HBoxContainer/Upload/UploadButton")
	fileUploadWindow = get_node("Control/FileUploadWindow")
	closeButton = get_node("Control/Header/Close")
	backButton = get_node("Control/Header/BackButton")
	profileSave = get_node("Control/Body/VBoxContainer/HBoxContainer/Avatar/ProfileButtons/Save")
	passwordSave = get_node("Control/Body/VBoxContainer/PasswordButtons/Save")
	profileCancel = get_node("Control/Body/VBoxContainer/HBoxContainer/Avatar/ProfileButtons/Cancel")
	passwordCancel = get_node("Control/Body/VBoxContainer/PasswordButtons/Cancel")
	
	username = get_node("Control/Body/VBoxContainer/HBoxContainer/VBoxContainer/Username/LineEdit")
	email = get_node("Control/Body/VBoxContainer/HBoxContainer/VBoxContainer/Email/LineEdit")
	cityName = get_node("Control/Body/VBoxContainer/HBoxContainer/VBoxContainer/CityName/LineEdit")
	avatar = get_node("Control/Body/VBoxContainer/HBoxContainer/Avatar/HBoxContainer/DisplayAvatar")
	oldPassword = get_node("Control/Body/VBoxContainer/OldPassword/LineEdit")
	newPassword = get_node("Control/Body/VBoxContainer/NewPassword/LineEdit")
	
	buttonSound = get_node("Control/ButtonSound")
	cancelSound = get_node("Control/CancelSound")
	
	profileSave.focus_mode = Control.FOCUS_NONE
	passwordSave.focus_mode = Control.FOCUS_NONE
	uploadFileButton.focus_mode = Control.FOCUS_NONE
	profileCancel.focus_mode = Control.FOCUS_NONE
	passwordCancel.focus_mode = Control.FOCUS_NONE

# connect signals and functions
func connect_signals():
	uploadFileButton.pressed.connect(_on_fileupload_button_pressed)
	fileUploadWindow.file_selected.connect(_on_file_upload_window_file_selected)
	closeButton.pressed.connect(_on_close_button_pressed)
	backButton.pressed.connect(_on_back_button_pressed)
	# Confirm Buttons
	profileSave.pressed.connect(edit_user_profile)
	passwordSave.pressed.connect(edit_user_password)
	profileCancel.pressed.connect(_on_back_button_pressed)
	passwordCancel.pressed.connect(_on_back_button_pressed)
	
	HttpLayer.http_completed.connect(http_completed)
	self.visibility_changed.connect(_on_visibility_changed)

func _on_close_button_pressed():
	cancelSound.play()
	self.hide()

func _on_back_button_pressed():
	cancelSound.play()
	self.hide()
	get_parent().get_child(1).show()


# display the window for uploading file when pressing button upload
func _on_fileupload_button_pressed():
	# play button sound
	buttonSound.play()
	
	if OS.get_name() == "Web":
		# javascript native window
		var window = JavaScriptBridge.get_interface("window")
		window.avatarInput.click()
	else:
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


# javascript callback
func js_file_uploaded(args):
	var imageBytes = imageURLToByte(args[0])
	# check if image size is valid (less than 64KB)
	if (imageBytes.size() > 65536):
		alert.set_message("Please keep avatar size in 64KB!")
		alert.popup_centered()
		return
	
	# show new avatar in game
	var isJPG = check_image_format(imageBytes)
	var avatarImage = Image.new()
	if (isJPG):
		avatarImage.load_jpg_from_buffer(imageBytes)
	else:
		avatarImage.load_png_from_buffer(imageBytes)
	var texture = ImageTexture.create_from_image(avatarImage)
	avatar.texture = texture
	# store file data in global variable
	uploadedFile = imageBytes

# decode BASE64 image String data
func imageURLToByte(dataURL: String) -> PackedByteArray:
	# Extract the Base64-encoded data part from the data URL
	var base64Data = dataURL.get_slice(',', 1)
	# Decode the Base64 data into raw bytes
	var imageBytes = Marshalls.base64_to_raw(base64Data)
	return imageBytes;



# connected with edit_profile button
# send saving profile request to server
func edit_user_profile():
	# play save button sound
	buttonSound.play()
	
	# check the validation of input
	if (!checkUsernameFormat(username.text)):
		alert.set_message("Username is invalid")
		alert.popup_centered()
		return
	if (!checkEmailFormat(email.text)):
		alert.set_message("Email is invalid")
		alert.popup_centered()
		return
	if (!checkCityNameFormat(cityName.text)):
		alert.set_message("City name is invalid")
		alert.popup_centered()
		return
	# store value of city name
	cityNameTempValue = cityName.text
	
	var httpRequest = HTTPRequest.new()
	add_child(httpRequest)
	httpRequest.request_completed.connect(self.edit_user_profile_request_completed.bind(httpRequest))
	
	var url = "http://localhost:8080/setting/editUserInfo"
	var headers = PackedStringArray(["Content-Type: multipart/form-data; boundary=MyBoundary"])
	headers.append(str("Authorization: ", GameManager.user_accessToken))
	
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
		"email": email.text,
		"cityName": cityName.text
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
	
	#if token is checked and valid, return true
	if !AlertPopup.tokenCheck(response):
		return
	
	if (response_code == 200):
		print(response.msg)
		# check if code in resultVO is 0000(SUCCESS)
		if (response.code != 0):
			alert.set_message(response.data)
			alert.popup_centered()
			return
		
		# update user_data in GameManager
		HttpLayer.fetch_user_info(GameManager.user_id)
		# update city name in GameManager
		GameManager.property_data.cityName = cityNameTempValue
		
		alert.set_message(response.data)
		alert.popup_centered()
	else:
		print(response_code)
		print("Unkown Error when editing profile")
		
	HttpLayer._destroyHttpObject(httpRequest)


# send editing password request to server
func edit_user_password():
	# play save button sound
	buttonSound.play()
	
	if (!checkPasswordFormat(oldPassword.text) || !checkPasswordFormat(newPassword.text)):
		alert.set_message("Password is invalid")
		alert.popup_centered()
		return
		
	HttpLayer.edit_user_password({
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
		
	var emailPattern = "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b"
	var regex = RegEx.new()
	regex.compile(emailPattern)
	return regex.search(str) != null

func checkCityNameFormat(str: String) -> bool:
	if (str == null):
		return false
	if (str.length() > 20 || str.length() < 1):
		return false
	return true


# callback function of http request
func http_completed(res, response_code, headers, route):
	#if token is checked and valid, return true
	if !AlertPopup.tokenCheck(res):
		return
	
	if (route != 'getUserInfo' && route != 'editPassword'):
		return
	
	if (response_code == 200):
		print(res.msg)
		# check if code in resultVO is 0000(SUCCESS)
		if (res.code != 0):
			if (route == "editPassword"):
				alert.set_message(res.data)
				alert.popup_centered()
				return
				
		if (route == "getUserInfo"):
			update_user_data(res.data)
			display_user_info(GameManager.user_data)
		elif (route == "editPassword"):
			alert.set_message(res.data)
			alert.popup_centered()
	if (route == "editPassword"):
			print("Fail to change password")

# update user_data in GameManager every time opening this scene
func update_user_data(data):
	GameManager.user_data.name = data.name
	GameManager.user_data.email = data.email
	GameManager.user_data.avatarStr = data.avatarStr

# diaplay user infomation as default text in line editor
func display_user_info(user_data):
	username.text = user_data.name
	email.text = user_data.email
	
	# display byte data of avatar
	var avatarStr = user_data.avatarStr
	if (avatarStr != null && avatarStr != ""):
		display_user_avatar(Marshalls.base64_to_raw(avatarStr))

# decode avatar data stored in string and display it
func display_user_avatar(avatarData: PackedByteArray):
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
