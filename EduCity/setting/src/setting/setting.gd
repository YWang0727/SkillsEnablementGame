extends Popup

var musicSlider: HSlider
var soundSlider: HSlider
var resumeButton: Button
var quitButton: Button
var saveButton: Button

# Called when the node enters the scene tree for the first time.
func _ready():
	initiate_variables()
	connect_signals()
	
	# default settings of volume
	musicSlider.value = GameManager.music_volume
	soundSlider.value = GameManager.sound_volume

func initiate_variables():
	musicSlider = get_node("Settings/VBoxContainer/Music/HSlider")
	soundSlider = get_node("Settings/VBoxContainer/Sound/HSlider")
	resumeButton = get_node("Settings/VBoxContainer/Resume")
	quitButton = get_node("Settings/VBoxContainer/Quit")
	saveButton = get_node("Settings/VBoxContainer/Save")
	
func connect_signals():
	resumeButton.pressed.connect(_on_resume_pressed)
	quitButton.pressed.connect(_on_quit_pressed)
	saveButton.pressed.connect(_on_save_pressed)
	# volume setting
	musicSlider.value_changed.connect(_on_music_volume_changed)
	soundSlider.value_changed.connect(_on_sound_volume_changed)

# control background music volume
func _on_music_volume_changed(value: float):
	GameManager.music_volume = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	AudioServer.set_bus_mute(0, value < 0.01)

# control sound effect volume
func _on_sound_volume_changed(value: float):
	GameManager.sound_volume = value
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

