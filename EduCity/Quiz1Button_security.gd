extends Button

#TODO: only when lesson1 is completed, Quiz1Button can be pressed and load the quiz!!!

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", _on_pressed)

func _on_pressed():
	GameManager.question_path = "res://LearningResources/IBM Security/module1/quiz.json"
	print(GameManager.question_path)
	get_tree().change_scene_to_file("res://quiz_scene.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
