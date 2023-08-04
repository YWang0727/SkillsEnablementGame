extends Control

var profile_scene: String = "res://setting/src/account/profile.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	$settingButton.pressed.connect(to_setting)
	$accountButton.pressed.connect(to_account)
	pass # Replace with function body.

	
func to_setting():
	$setting.popup_centered()

func to_account():
	get_tree().change_scene_to_file(profile_scene)
