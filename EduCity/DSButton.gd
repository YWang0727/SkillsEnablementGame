extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", _on_pressed)

func _on_pressed():
	var popup = get_node("../PopupMenu")
	popup.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
