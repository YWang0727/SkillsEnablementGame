extends Control

var isExpanded = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _onToggleButtonPressed():
	if isExpanded:
		set_position(Vector2(1920, 0))
		isExpanded = false
	else:
		set_position(Vector2(1620, 0))
		isExpanded = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
