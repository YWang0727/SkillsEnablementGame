extends ColorRect

var closeButton = Button.new()
var lesson1Button = Button.new()
var quiz1Button = Button.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	closeButton = get_node("CloseButton")
	closeButton.connect("pressed", _on_closeButton_pressed)
	
	lesson1Button = get_node("Lesson1Button")
	lesson1Button.connect("pressed", _on_lesson1Button_pressed)
	
	quiz1Button = get_node("Quiz1Button")
	quiz1Button.connect("pressed", _on_quiz1Button_pressed)


func _on_closeButton_pressed():
	self.visible = false
	
	
func _on_lesson1Button_pressed():
	GameManager.reading_path = ""
	get_tree().change_scene_to_file("res://reading_scene.tscn")


func _on_quiz1Button_pressed():
	GameManager.question_path = ""
	print(GameManager.question_path)
	get_tree().change_scene_to_file("res://quiz_scene.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
