extends "res://loginPage/login_signIn.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_eye_hide_toggled(button_pressed):
	changePasswordHideState()
	
func changePasswordHideState():
	#password1Sign.set_secret(!password1Sign.secret)
	var textTmp = "hello"
	print(textTmp)
	#print(password1Sign.text)
