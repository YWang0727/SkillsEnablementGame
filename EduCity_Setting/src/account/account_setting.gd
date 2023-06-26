extends Control

var profile_scene: String = "res://src/account/profile.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_signals()


# connect signals and functions
func connect_signals():
	$Edit/VBoxContainer/Avatar/HBoxContainer/Upload/UploadButton.pressed.connect(_on_fileupload_button_pressed)
	$FileUploadWindow.file_selected.connect(_on_file_upload_window_file_selected)
	$BackButton.pressed.connect(_on_back_button_pressed)
	
	# Confirm Buttons
	$Edit/VBoxContainer/ProfileButtons/Save.pressed.connect(_on_profile_save_pressed)
	$Edit/VBoxContainer/PasswordButtons/Save.pressed.connect(_on_password_save_pressed)
	$Edit/VBoxContainer/ProfileButtons/Cancel.pressed.connect(_on_back_button_pressed)
	$Edit/VBoxContainer/PasswordButtons/Cancel.pressed.connect(_on_back_button_pressed)
	
	
func _on_back_button_pressed():
	get_tree().change_scene_to_file(profile_scene)
	
func _on_profile_save_pressed():
	pass
	
# send edit password request to server
func _on_password_save_pressed():
	pass

# display the window of uploading file
func _on_fileupload_button_pressed():
	$FileUploadWindow.popup_centered()

# process the uploaded file
func _on_file_upload_window_file_selected(path: String):
	# show new avatar
	var avatarImage = Image.new()
	avatarImage.load(path)
	var texture = ImageTexture.create_from_image(avatarImage)
	$Edit/VBoxContainer/Avatar/HBoxContainer/DisplayAvatar.texture = texture
	
	# save avatar to server
	# TODO

