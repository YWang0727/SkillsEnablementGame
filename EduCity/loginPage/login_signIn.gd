extends Control

var logButton 
var signButton

# Called when the node enters the scene tree for the first time.
func _ready():
	logButton = get_node("Tabars/HBoxContainer/Log in")
	signButton = get_node("Tabars/HBoxContainer/Sign in")
	logButton.connect("pressed",  _on_log_in_pressed)
	#signButton.connect("button_down", _on_sign_in_toggled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_log_in_pressed():
	logButton.set_pressed(true)
	signButton.set_pressed(false)


func _on_sign_in_pressed():
	logButton.set_pressed(false)
	signButton.set_pressed(true)
