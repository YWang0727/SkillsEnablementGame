extends Button



# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", _on_Button_pressed)


func _on_Button_pressed():
	OS.shell_open("https://www.ibm.com/academic/topic")
	
