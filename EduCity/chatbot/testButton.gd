extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	get_tree().change_scene_to_file("res://chatbot/chatbot.tscn")
