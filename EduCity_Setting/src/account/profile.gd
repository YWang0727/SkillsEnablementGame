extends Control

var account_setting_scene:String = "res://src/account/account_setting.tscn"
var world_scene: String = ("res://src/sim_world/world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_connect()

func signal_connect():
	$MarginContainer/Profile/BasicInfo/EditButton.pressed.connect(_on_edit_button_pressed)
	$BackButton.pressed.connect(_on_back_button_pressed)

func _on_edit_button_pressed():
	get_tree().change_scene_to_file(account_setting_scene)

func _on_back_button_pressed():
	get_tree().change_scene_to_file(world_scene)
