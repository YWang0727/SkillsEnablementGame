extends Control

#var profile_scene = preload("res://setting/src/account/profile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/settingButton.pressed.connect(to_setting)
	$VBoxContainer/accountButton.pressed.connect(to_profile)
	
func to_setting():
	$Setting.show()

func to_profile():
	$Profile.show()
	#get_tree().change_scene_to_file(profile_scene)
