extends Node2D

var backButton = Button.new()
var closeButton = Button.new()

var aiButton = Button.new()
var securityButton = Button.new()
var cloudButton = Button.new()
var dsButton = Button.new()
var automationButton = Button.new()

var lesson1Button = Button.new()
var lesson2Button = Button.new()
var lesson3Button = Button.new()
var quiz1Button = Button.new()
var quiz2Button = Button.new()
var quiz3Button = Button.new()

var completeList = []
var buttonList = []


# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.connect("http_completed", http_completed)
	
	backButton = get_node("BackButton")
	backButton.connect("pressed", _on_backButton_pressed)
	
	closeButton = get_node("PopupMenu/CloseButton")
	closeButton.connect("pressed", _on_closeButton_pressed)
	
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
	
	lesson3Button = get_node("PopupMenu/Lesson3Button")
	lesson3Button.connect("pressed", _on_lesson3Button_pressed)
	lesson3Button.visible = false
	
	quiz1Button = get_node("PopupMenu/Quiz1Button")
	quiz1Button.disabled = true
	quiz1Button.connect("pressed", _on_quiz1Button_pressed)
	
	quiz2Button = get_node("PopupMenu/Quiz2Button")
	quiz2Button.disabled = true
	quiz2Button.connect("pressed", _on_quiz2Button_pressed)
	
	quiz3Button = get_node("PopupMenu/Quiz3Button")
	quiz3Button.disabled = true
	quiz3Button.connect("pressed", _on_quiz3Button_pressed)
	quiz3Button.visible = false
	
	_set_status()
	
	
# get each knowledge session's status
func _set_status():
	var labelList = [get_node("AI/AIButton/Status"), get_node("Security/SecurityButton/Status"), 
	get_node("Cloud/CloudButton/Status"), get_node("DS/DSButton/Status"), get_node("Automation/AutomationButton/Status")]
	
	for i in GameManager.statusList.size():
		if GameManager.statusList[i] == 0:
			labelList[i].text = "not started"
		elif GameManager.statusList[i] == 1:
			labelList[i].text = "in progress"
		else:
			labelList[i].text = "completed"
	
	
# generate lesson/quiz path
func _on_lesson1Button_pressed():
	GameManager.reading_path = GameManager.reading_path + "/module1/reading.md"
	get_tree().change_scene_to_file("res://loading_scene.tscn")


func _on_lesson2Button_pressed():
	GameManager.reading_path = GameManager.reading_path + "/module2/reading.md"
	get_tree().change_scene_to_file("res://loading_scene.tscn")
	

func _on_lesson3Button_pressed():
	GameManager.reading_path = GameManager.reading_path + "/module3/reading.md"
	get_tree().change_scene_to_file("res://loading_scene.tscn")
	

func _on_quiz1Button_pressed():
	GameManager.question_path = GameManager.question_path + "/module1/quiz.json"
	get_tree().change_scene_to_file("res://quiz_scene.tscn")
	
	
func _on_quiz2Button_pressed():
	GameManager.question_path = GameManager.question_path + "/module2/quiz.json"
	get_tree().change_scene_to_file("res://quiz_scene.tscn")
	
	
func _on_quiz3Button_pressed():
	GameManager.question_path = GameManager.question_path + "/module3/quiz.json"
	get_tree().change_scene_to_file("res://quiz_scene.tscn")


func _on_backButton_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn")
	
	
# generate module path
func _on_aiButton_pressed():
	GameManager.reading_path = "res://LearningResources/IBM AI"
	GameManager.question_path = "res://LearningResources/IBM AI"
	
	var popup = get_node("PopupMenu")
	popup.visible = true
	
	_show_buttons(1)


func _on_securityButton_pressed():
	GameManager.reading_path = "res://LearningResources/IBM Security"
	GameManager.question_path = "res://LearningResources/IBM Security"
	
	var popup = get_node("PopupMenu")
	popup.visible = true
	
	_show_buttons(2)
	
	
func _on_cloudButton_pressed():
	GameManager.reading_path = "res://LearningResources/IBM Cloud"
	GameManager.question_path = "res://LearningResources/IBM Cloud"
	
	var popup = get_node("PopupMenu")
	popup.visible = true
	
	_show_buttons(3)
	
	
func _on_dsButton_pressed():
	GameManager.reading_path = "res://LearningResources/IBM DS"
	GameManager.question_path = "res://LearningResources/IBM DS"
	
	var popup = get_node("PopupMenu")
	popup.visible = true
	
	_show_buttons(4)
	
	
func _on_automationButton_pressed():
	GameManager.reading_path = "res://LearningResources/IBM Automation"
	GameManager.question_path = "res://LearningResources/IBM Automation"
	
	var popup = get_node("PopupMenu")
	popup.visible = true
	
	_show_buttons(5)
	
	
func _on_closeButton_pressed():
	lesson3Button.visible = false
	quiz3Button.visible = false
	get_node("PopupMenu").visible = false
	
	
func _show_buttons(knowledge):
	var module3_path = GameManager.reading_path + "/module3/reading.md"
	if FileAccess.file_exists(module3_path):
		lesson3Button.visible = true
		quiz3Button.visible = true
	
	# check if quizzes under current knowledge are available
	HttpLayer._checkQuiz({
			"id": GameManager.user_id,
			"knowledge": knowledge
		})
		
		
func http_completed(res, response_code, headers, route) -> void:
	if response_code == 200:
		completeList = res['completeList']
		# if lesson completed and quiz attempts didn't meet maximum
		for index in completeList.size():
			if(completeList[index].attempts != 3):
				buttonList.append(str(completeList[index].quizid).substr(1,1))
		print(buttonList)
		for index in buttonList.size():
			match buttonList[index]:
				"1":
					quiz1Button.disabled = false
				"2":
					quiz2Button.disabled = false
				"3":
					quiz3Button.disabled = false
					
	else:
		print("lesson not finished yet")
		return

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
