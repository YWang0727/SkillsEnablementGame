extends Control

@export var message: String
@export var arrowDirection: bool

# vertical margin of label
var labelMarginY = 60
var labelMarginX = 100

func _ready():
	# set width, height, and text of bubble
	var width = message.length() * 15 + labelMarginX
	self.size.x = min(500, width)
	$PanelContainer/Message.text = message
	self.size.y = $PanelContainer/Message.size.y + labelMarginY
	
func _process(delta):
	set_arrow_direction()
	# set width, height, and text of bubble
	var width = message.length() * 15 + labelMarginX
	self.size.x = min(500, width)
	$PanelContainer/Message.text = message
	self.size.y = $PanelContainer/Message.size.y + labelMarginY
	
	# set the position of right arrow according to bubble size
	$RightArrow.position.x = self.size.x - 70
	

# set left arrow if true, otehrwise set to right
func set_arrow_direction():
	if (arrowDirection):
		$LeftArrow.show()
		$RightArrow.hide()
	else:
		$LeftArrow.hide()
		$RightArrow.show()
