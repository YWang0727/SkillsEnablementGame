extends CanvasLayer

var musicSlider: HSlider
var soundSlider: HSlider
var closeButton: Button
var exitButton: Button
var saveButton: Button
var buttonSound: AudioStreamPlayer2D
var cancelSound: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	initiate_variables()
	connect_signals()
	
	# default settings of volume
	musicSlider.value = GameManager.music_volume
	soundSlider.value = GameManager.sound_volume

func initiate_variables():
	musicSlider = get_node("Control/Body/VBoxContainer/Music/HSlider")
	soundSlider = get_node("Control/Body/VBoxContainer/Sound/HSlider")
	closeButton = get_node("Control/Header/Close")
	exitButton = get_node("Control/Body/VBoxContainer/Exit")
	saveButton = get_node("Control/Body/VBoxContainer/Save")
	buttonSound = get_node("Control/ButtonSound")
	cancelSound = get_node("Control/CancelSound")
	
	saveButton.focus_mode = Control.FOCUS_NONE
	exitButton.focus_mode = Control.FOCUS_NONE
	closeButton.focus_mode = Control.FOCUS_NONE

func connect_signals():
	closeButton.pressed.connect(_on_close_pressed)
	exitButton.pressed.connect(_on_exit_pressed)
	saveButton.pressed.connect(_on_save_pressed)
	# volume setting
	musicSlider.value_changed.connect(_on_music_volume_changed)
	soundSlider.value_changed.connect(_on_sound_volume_changed)

# control background music volume
func _on_music_volume_changed(value: float):
	GameManager.music_volume = value
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	AudioServer.set_bus_mute(1, value < 0.01)

# control sound effect volume
func _on_sound_volume_changed(value: float):
	GameManager.sound_volume = value
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	AudioServer.set_bus_mute(2, value < 0.01)


# go back to world window
func _on_close_pressed():
	cancelSound.play()
	self.hide()

# save game data to server
func _on_save_pressed():
	buttonSound.play()
	Saving.save()
	
# exit game
func _on_exit_pressed():
	Saving.save_auto()
	GameManager.initialize_global_variables()
	buttonSound.finished.connect(_on_exit_helper)
	buttonSound.play()

func _on_exit_helper():
	get_tree().change_scene_to_file("res://loginPage/login.tscn")
