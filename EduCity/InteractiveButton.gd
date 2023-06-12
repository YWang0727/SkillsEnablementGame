extends Button

var isExpanded = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", get_parent()._onToggleButtonPressed)
	self.connect("pressed", _onPressed)

func _onPressed():
	if isExpanded:
		set_position(Vector2(1895, 510))
		isExpanded = false
	else:
		set_position(Vector2(1600, 510))
		isExpanded = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
