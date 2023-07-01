extends Node2D

var richTextLabel = RichTextLabel.new()
var exitButton = Button.new()
var completedButton = Button.new()
var scrollContainer = ScrollContainer.new()
var vScrollbar = VScrollBar.new()

#var isScrollingToBottom: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	richTextLabel = get_node("ScrollContainer/VBoxContainer/RichTextLabel")
	exitButton = get_node("ExitButton")
	completedButton = get_node("ScrollContainer/VBoxContainer/CompletedButton")
	scrollContainer = get_node("ScrollContainer")
	
	# load reading material
	_load_reading(GameManager.reading_path)
	
	# click url
	richTextLabel.connect("meta_clicked", _richtextlabel_on_meta_clicked)
	
	completedButton.connect("pressed", _on_completedButton_clicked)
	# check if scroll to bottom
	#completedButton.visible = false
	#vScrollbar.connect("value_changed", _scroll_to_bottom)
	#scrollContainer.connect("scroll_started", _on_scroll_moved)
	#vScrollbar = scrollContainer.get_v_scroll_bar()

	# exit button
	exitButton.connect("pressed", _on_exitButton_pressed)
	
	
func _load_reading(file_path: String):
	if FileAccess.file_exists(file_path):
		var dataFile = FileAccess.open(file_path, FileAccess.READ)
		var reading_text = dataFile.get_as_text()
		
		richTextLabel.bbcode_enabled = true
		richTextLabel.parse_bbcode(reading_text) 
		
	else:
		print("File doesn't exist!")


func _on_completedButton_clicked():
	#TODO: 存储reading完成数据到数据库！！！
	get_tree().change_scene_to_file("res://learning_scene.tscn")
	
	
#func _scroll_to_bottom(value: float):
#	print("111")
#	if isScrollingToBottom and value >= vScrollbar.max_value:
#		completedButton.visible = true
		
	
func _on_exitButton_pressed():
	get_tree().change_scene_to_file("res://learning_scene.tscn")
	
	
func _richtextlabel_on_meta_clicked(meta):
	OS.shell_open(str(meta))
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	_scroll_to_bottom()
