extends Popup



# Called when the node enters the scene tree for the first time.
func _ready():
	connect_signals()
	
	# default settings of volume
	$Settings/VBoxContainer/Music/HSlider.value = 0.7
	$Settings/VBoxContainer/Sound/HSlider.value = 0.7

func connect_signals():
	$Settings/VBoxContainer/Resume.pressed.connect(_on_resume_pressed)
	$Settings/VBoxContainer/Quit.pressed.connect(_on_quit_pressed)
	$Settings/VBoxContainer/Save.pressed.connect(_on_save_pressed)
	# volume setting
	$Settings/VBoxContainer/Music/HSlider.value_changed.connect(_on_music_volume_changed)
	$Settings/VBoxContainer/Sound/HSlider.value_changed.connect(_on_sound_volume_changed)

# control background music volume
func _on_music_volume_changed(value: float):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	AudioServer.set_bus_mute(0, value < 0.01)

# control sound effect volume
func _on_sound_volume_changed(value: float):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	AudioServer.set_bus_mute(1, value < 0.01)


# go back to world window
func _on_resume_pressed():
	self.hide()

# save game data to server
func _on_save_pressed():
	# TODO
	pass

# quit game
func _on_quit_pressed():
	get_tree().quit()

