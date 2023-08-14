extends Panel

signal update_components

var getGolds = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


func _on_ok_pressed():
	self.hide()

