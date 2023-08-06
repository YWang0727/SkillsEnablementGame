extends Control

@export var message: String
@export_enum("left", "right", "none") var arrow: String
@export var clickable: bool

signal option_selected(bubble: Control)

# vertical margin of label
var labelMarginY = 60
var labelMarginX = 100


func _ready():
	set_arrow_visibility()
	adjust_bubble_size()
	# set the position of right arrow according to bubble size
	$RightArrow.position.x = self.size.x - 70
	# set the color of bubble
	if (arrow == "none"):
		var new_stylebox = get_node("PanelContainer").get_theme_stylebox("panel").duplicate()
		new_stylebox.bg_color = Color(0.6, 0.6, 0.6)
		get_node("PanelContainer").add_theme_stylebox_override("panel",new_stylebox)
	elif (arrow == "right"):
		var new_stylebox = get_node("PanelContainer").get_theme_stylebox("panel").duplicate()
		new_stylebox.bg_color = Color(0.25, 0.67, 0.68)
		get_node("PanelContainer").add_theme_stylebox_override("panel",new_stylebox)
	
	$PanelContainer.gui_input.connect(option_container_pressed)
	
func _process(delta):
	adjust_bubble_size()
	# set the position of right arrow according to bubble size
	$RightArrow.position.x = self.size.x - 70


# make valid options clickable
func option_container_pressed(event: InputEvent):
	if (!clickable):
		return
		
	if (event.is_action_pressed("leftclick")):
		emit_signal("option_selected", self)

# set width, height, and text of bubble
func adjust_bubble_size():
	var width = message.length() * 15 + labelMarginX
	self.size.x = min(500, width)
	$PanelContainer/Message.text = message
	self.size.y = $PanelContainer/Message.size.y + labelMarginY

# set left arrow visible if message is sent by watson
# set right arrow visible if it's sent by user
# set both arrows invisible if it's an option
func set_arrow_visibility():
	if (arrow == "left"):
		$LeftArrow.show()
		$RightArrow.hide()
	elif (arrow == "right"):
		$LeftArrow.hide()
		$RightArrow.show()
	else:
		$LeftArrow.hide()
		$RightArrow.hide()
