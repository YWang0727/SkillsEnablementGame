extends ColorRect

var profile_scene: String = "res://src/account/profile.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	$settingButton.pressed.connect(to_setting)
	$accountButton.pressed.connect(to_account)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func to_setting():
	$setting.popup_centered()

func to_account():
	get_tree().change_scene_to_file(profile_scene)
