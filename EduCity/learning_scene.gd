extends Node2D

var backButton = Button.new()

var aiButton = Button.new()
var securityButton = Button.new()
var cloudButton = Button.new()
var dsButton = Button.new()
var automationButton = Button.new()

var lesson1Button = Button.new()
var lesson2Button = Button.new()
var quiz1Button = Button.new()
var quiz2Button = Button.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	backButton = get_node("BackButton")
	backButton.connect("pressed", _on_backButton_pressed)
	
	aiButton = get_node("AI/AIButton")
	aiButton.connect("pressed", _on_aiButton_pressed)
	
	securityButton = get_node("Security/SecurityButton")
	securityButton.connect("pressed", _on_securityButton_pressed)
	
	cloudButton = get_node("Cloud/CloudButton")
	cloudButton.connect("pressed", _on_cloudButton_pressed)
	
	dsButton = get_node("DS/DSButton")
	dsButton.connect("pressed", _on_dsButton_pressed)
	
	automationButton = get_node("Automation/AutomationButton")
	automationButton.connect("pressed", _on_automationButton_pressed)
	
	lesson1Button = get_node("PopupMenu/Lesson1Button")
	lesson1Button.connect("pressed", _on_lesson1Button_pressed)
	
	lesson2Button = get_node("PopupMenu/Lesson2Button")
	lesson2Button.connect("pressed", _on_lesson2Button_pressed)
	
	quiz1Button = get_node("PopupMenu/Quiz1Button")
	quiz1Button.connect("pressed", _on_quiz1Button_pressed)
	
	quiz1Button = get_node("PopupMenu/Quiz2Button")
	quiz1Button.connect("pressed", _on_quiz2Button_pressed)
	
	
# generate lesson/quiz path
func _on_lesson1Button_pressed():
	GameManager.reading_path = GameManager.reading_path + "/module1/reading.md"
	get_tree().change_scene_to_file("res://reading_scene.tscn")


func _on_lesson2Button_pressed():
	GameManager.reading_path = GameManager.reading_path + "/module2/reading.md"
	get_tree().change_scene_to_file("res://reading_scene.tscn")
	

func _on_quiz1Button_pressed():
	GameManager.question_path = GameManager.question_path + "/module1/quiz.json"
	get_tree().change_scene_to_file("res://quiz_scene.tscn")
	
	
func _on_quiz2Button_pressed():
	GameManager.question_path = "/module2/quiz.json"
	get_tree().change_scene_to_file("res://quiz_scene.tscn")
	

func _on_backButton_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn")


# generate module path
func _on_aiButton_pressed():
	GameManager.reading_path = "res://LearningResources/IBM AI"
	GameManager.question_path = "res://LearningResources/IBM AI"
	
	var popup = get_node("PopupMenu")
	popup.visible = true


func _on_securityButton_pressed():
	GameManager.reading_path = "res://LearningResources/IBM Security"
	GameManager.question_path = "res://LearningResources/IBM Security"
	
	var popup = get_node("PopupMenu")
	popup.visible = true
	
	
func _on_cloudButton_pressed():
	GameManager.reading_path = "res://LearningResources/IBM Cloud"
	GameManager.question_path = "res://LearningResources/IBM Cloud"
	
	var popup = get_node("PopupMenu")
	popup.visible = true
	
	
func _on_dsButton_pressed():
	GameManager.reading_path = "res://LearningResources/IBM DS"
	GameManager.question_path = "res://LearningResources/IBM DS"
	
	var popup = get_node("PopupMenu")
	popup.visible = true
	
	
func _on_automationButton_pressed():
	GameManager.reading_path = "res://LearningResources/IBM Automation"
	GameManager.question_path = "res://LearningResources/IBM Automation"
	
	var popup = get_node("PopupMenu")
	popup.visible = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
