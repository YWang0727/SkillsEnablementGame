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
	
	GameManager.user_id = 1
	
	fetch_user_info()

func initiate_variales():
	account_API = HttpLayer_Account.new()
	add_child(account_API)
	
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



# fetched user basic infomation from server
func fetch_user_info():
	HttpLayer.http_completed.connect(display_user_info)
	account_API.fetch_user_info(GameManager.user_id)

# diaplay user infomation as default text in line editor
func display_user_info(res, response_code, headers, route):
	username.text = res.name
	email.text = res.email
	
	var avatarUrl = res.avatar
	# if url is empty, display default image
	if (avatarUrl != "" && avatarUrl != null):
		fetch_user_avatar(avatarUrl)

# get avatar data by calling avatar url
func fetch_user_avatar(avatarUrl: String):
	var httpRequest = HTTPRequest.new()
	add_child(httpRequest)
	
	httpRequest.request(avatarUrl)
	httpRequest.request_completed.connect(display_user_avatar)

func display_user_avatar(result, result_code, headers, body):
	var image = Image.new()
	image.load_png_from_buffer(body)
	var image_texture = ImageTexture.create_from_image(image)
	avatar.texture = image_texture


# display the window for uploading file when pressing button upload
func _on_fileupload_button_pressed():
	fileUploadWindow.popup_centered()

# process the uploaded file
func _on_file_upload_window_file_selected(path: String):
	# show new avatar in game
	var avatarImage = Image.new()
	avatarImage.load(path)
	var texture = ImageTexture.create_from_image(avatarImage)
	avatar.texture = texture
	
	# get avatar's byte data and store in global variable file
	uploadedFile = FileAccess.get_file_as_bytes(path)


# send saving profile request to server
func edit_user_profile():
	var httpRequest = HTTPRequest.new()
	add_child(httpRequest)
	
	var url = "http://localhost:8080/setting/editUserInfo"
	var headers = PackedStringArray(["Content-Type: multipart/form-data; boundary=MyBoundary"])
	
	# create the body part of editing user info request
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





# TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
# send editing password request to server
func edit_user_password():
	account_API.edit_user_password({
		"userId": GameManager.user_id,
		"oldPassword": oldPassword.text,
		"newPassword": newPassword.text
	})


# check the format of profile at the front end
func check_profile_format():
	alert.set_message("Wrong old password")
	alert.popup_centered_ratio(0.3)

# check the format of password at the frond end
func check_password_format():
	alert.set_message("Wrong old password")
	alert.popup_centered_ratio(0.3)

