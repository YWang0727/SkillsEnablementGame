extends Control

var logButton 
var signButton
var logPanel
var signPanel
var resetButton
var usernameSign
var emailSign
var password1Sign
var password2Sign

# Called when the node enters the scene tree for the first time.
func _ready():
	logButton = get_node("Tabars/HBoxContainer/Log in")
	signButton = get_node("Tabars/HBoxContainer/Sign in")
	logPanel = get_node("log_in")
	signPanel = get_node("sign_in")
	logButton.connect("pressed",  _on_log_in_pressed)
	signButton.connect("pressed", _on_sign_in_pressed)
	
	resetButton = get_node("sign_in/sign_in_button_panel/reset_button")
	resetButton.connect("pressed", _on_reset_button_pressed)
	
	usernameSign = get_node("sign_in/username_panel/LineEdit")
	emailSign = get_node("sign_in/email_input_panel/LineEdit")
	password1Sign =get_node("sign_in/pw_input1_panel/LineEdit")
	password2Sign = get_node("sign_in/pw_input2_panel/LineEdit")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_log_in_pressed():
	logButton.set_pressed(true)
	signButton.set_pressed(false)
	logPanel.visible = true
	signPanel.visible = false

func _on_sign_in_pressed():
	logButton.set_pressed(false)
	signButton.set_pressed(true)
	signPanel.visible = true
	logPanel.visible = false

func _on_reset_button_pressed():
	usernameSign.text = ""
	emailSign.text = ""
	password1Sign.text = ""
	password2Sign.text = ""
	
