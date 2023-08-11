extends AcceptDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	self.size.x = 400
	self.size.y = 250

func show_error_message(message: String):
	self.title = "Alert!"
	self.set_text("\n" +message)
	self.show()

func hide_error_message():
	self.hide()
	
func setSize(sizeX: int, sizeY: int):
	self.size.x = sizeX
	self.size.y = sizeY
	
func setPosition(positionX: int, positionY: int, positionType: String):
	if positionType == 'center' :
		self.position.x = 760
		self.position.y = 400
	elif positionType == 'login':
		self.position.x = 350
		self.position.y = 400
	else:
		self.position.x = positionX
		self.position.y = positionY
		
func tokenCheck(res) -> bool:
	if res != null && res.has("code"):
		if res.code == 1001 || res.code == 1003:
			AlertPopup.setPosition(0,0,'center')
			AlertPopup.show_error_message(res.data)
			get_tree().change_scene_to_file("res://loginPage/login.tscn")
			return false
	return true
