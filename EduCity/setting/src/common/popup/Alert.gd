extends Popup


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Button.pressed.connect(hide_alert)

func hide_alert():
	self.hide()
	
func set_message(message: String):
	$VBoxContainer/Message.text = message
