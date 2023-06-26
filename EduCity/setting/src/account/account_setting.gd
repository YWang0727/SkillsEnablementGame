extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	connect_signals()


# connect signals and functions
func connect_signals():
	$EditProfile/VBoxContainer/Avatar/UploadButton.pressed.connect(_on_fileupload_button_pressed)
	$FileUploadWindow.file_selected.connect(_on_file_upload_window_file_selected)
	$EditPassword/VBoxContainer/Password/EditPassword.pressed.connect(edit_password)


# display the window of uploading file
func _on_fileupload_button_pressed():
	$FileUploadWindow.popup_centered()

# process the uploaded file
func _on_file_upload_window_file_selected(path: String):
	# show new avatar
	var avatarImage = Image.new()
	avatarImage.load(path)
	var texture = ImageTexture.create_from_image(avatarImage)
	$DisplayAvatar.texture = texture
	
	# save avatar to server
	# TODO


# send edit password request to server
func edit_password():
	# TODO
	pass
