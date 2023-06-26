extends Control

var account_setting_scene:PackedScene = preload("res://src/account/account_setting.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/VBoxContainer/EditButton.pressed.connect(_on_editbutton_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_editbutton_pressed():
	get_tree().change_scene_to_packed(account_setting_scene)
