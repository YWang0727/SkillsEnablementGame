extends CanvasLayer

var quizId = null
var knowledgeId = null
var quizConfig = {}
var currentQuestionIndex := 0
var questionSize := 0
var quizData := {}

# init compons
var questionLabel := Label.new()
var noLabel := Label.new()
var alertPopup := AcceptDialog.new()
var cancelButton := Button.new()
var optionsButtonContainer := VBoxContainer.new()
var navigationButtonContainer := HBoxContainer.new()
var previousButton := Button.new()
var nextButton := Button.new()
var submitButton := Button.new()
var showScore := ColorRect.new()
var exitButton := Button.new()

# store answers and final score
var optionsArray = []
var selectedArray = []
var answerArray = []
var finalScore = 0
var scoreDifference = 0
var attempts = null
var golds = null

signal quiz_add_gold_show


# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.connect("http_completed", http_completed)
	
	quizId = _get_quizId("user://quizConfig.json")

	_load_questions_from_json(GameManager.question_path)
	
	# create question node
	questionLabel  = get_node("QuestionLabel")
	
	noLabel = get_node("NoLabel")
	alertPopup = get_node("AlertPopup")
	cancelButton = alertPopup.add_button(" CANCEL ", true)
	
	optionsButtonContainer = get_node("OptionsButtonContainer")
	
	#create navigation botton node
	navigationButtonContainer = get_node("NavigationButtonContainer")
	previousButton.icon = ResourceLoader.load("res://XufengPart/Icons/left.png")
	previousButton.expand_icon = true
	previousButton.visible = true
	previousButton.custom_minimum_size.x = 70
	previousButton.custom_minimum_size.y = 70
	previousButton.connect("pressed",_on_previous_button_pressed)
	navigationButtonContainer.add_child(previousButton)
	
	nextButton.icon = ResourceLoader.load("res://XufengPart/Icons/right.png")
	nextButton.expand_icon = true
	nextButton.visible = true
	nextButton.custom_minimum_size.x = 70
	nextButton.custom_minimum_size.y = 70	
	nextButton.connect("pressed",_on_next_button_pressed)
	navigationButtonContainer.add_child(nextButton)
	
	#create submit button node
	submitButton.icon = ResourceLoader.load("res://LearningPage/Icon/submit.png")
	submitButton.expand_icon = true
	submitButton.visible = false
	submitButton.custom_minimum_size.x = 70
	submitButton.custom_minimum_size.y = 70
	submitButton.connect("pressed",_on_submit_button_pressed)
	navigationButtonContainer.add_child(submitButton)
	
	showScore = get_node("ShowScore")
	showScore.visible = false
	
	exitButton = get_node("ExitButton")
	exitButton.connect("pressed", _on_exit_pressed)
	
	# show the first question
	_show_question(currentQuestionIndex)
	
	
func _get_quizId(file_path: String):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json_text = file.get_as_text()
		var config = JSON.new()
		var result = config.parse(json_text)
		if result != OK:
			print("JSON parsing error:", result.error_string)
			return
		var quizConfig = config.get_data()
		file.close()
		
		if quizConfig.has(GameManager.question_path):
			return var_to_str(quizConfig[GameManager.question_path])
		else:
			print("Quiz ID not found for file:", file_path)
			return -1
	else:
		print("File doesn't exist!")
	
	
func _load_questions_from_json(file_path: String) -> void:
	if FileAccess.file_exists(file_path):
		#load .json file
		var dataFile = FileAccess.open(file_path, FileAccess.READ)
		var json_text = dataFile.get_as_text()
		var parser = JSON.new()
		var result = parser.parse(json_text)
		if result != OK:
			print("JSON parsing error:", result.error_string)
			return
			
		#generate data
		quizData = parser.get_data()
		#print(quizData)
		
		#store answers from .json
		questionSize = quizData.questions.size()
		for i in range(questionSize):
			answerArray.append(quizData.questions[i].answers)
		print(answerArray)
		
		#change selectedArray's size
		selectedArray.resize(questionSize)
		
	else:
		print("File doesn't exist!")
		
		
func _show_question(index: int):
	# show current question no.
	noLabel.text = str(index + 1) + " / " + str(questionSize)
	
	# if is multi-answers or not
	var multi = false
	if answerArray[index].size() > 1:
		multi = true
		
	if index < 0 or index >= questionSize:
		return

	var question: Dictionary = quizData.questions[index]
	# show current question
	questionLabel = get_node("QuestionLabel") as Label
	questionLabel.text = "  " + question["question"]

	# clear previous options
	_clear_container(optionsButtonContainer)
	
	# show every option button
	for optionIndex in question.options.size():
		var option = question.options[optionIndex]
		var button := Button.new()
		button.text = option
		button.add_theme_font_size_override("font_size", 25)
		button.custom_minimum_size.x = 200
		button.custom_minimum_size.y = 70
		button.pressed.connect(_on_option_button_pressed.bind(multi, button, index, optionIndex))
		optionsButtonContainer.add_child(button)


func _clear_container(container: Node):
	while container.get_child_count() > 0:
		var child := container.get_child(0)
		container.remove_child(child)
		child.queue_free()


func _on_next_button_pressed():
	currentQuestionIndex  = currentQuestionIndex + 1
	_show_question(currentQuestionIndex)
	
	
func _on_previous_button_pressed():
	currentQuestionIndex = currentQuestionIndex - 1
	_show_question(currentQuestionIndex)
		

func _on_option_button_pressed(multi: bool, button:Button, questionIndex: int, optionIndex: int):
	var new_stylebox_normal = button.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = Color("969696")
	# if is not multi-answer
	if multi == false:
		# set other buttons color to default
		for i in optionsButtonContainer.get_children():
			var otherButton = i as Button
			otherButton.remove_theme_stylebox_override("normal")
		
		# set button color when pressed
		button.add_theme_stylebox_override("normal", new_stylebox_normal)
		
		# add selected options to selectedArray
		selectedArray[questionIndex] = [optionIndex]
		
	# if is multi-answer	
	else:
		var selectedOptions = selectedArray[questionIndex]
		# create selected array
		if selectedOptions == null:
			selectedOptions = []
		var optionIndexIndex = selectedOptions.find(optionIndex)
		
		# if current option hasn't been selected
		if optionIndexIndex == -1:
			# add to array
			button.add_theme_stylebox_override("normal", new_stylebox_normal)
			selectedOptions.append(optionIndex)
		else:
			# remove from array
			button.remove_theme_stylebox_override("normal")
			selectedOptions.erase(optionIndex)
		selectedOptions.sort()
		selectedArray[questionIndex] = selectedOptions
	print(selectedArray)


func _on_submit_button_pressed():
	submitButton.disabled = true
	print("submit success")
	
	# calculate final score
	_calcu_score()
	# submit quiz data to backend
	knowledgeId = quizId.substr(0, 1)
	quizId = quizId.substr(1, 1)
	HttpLayer._submitQuiz({
				"id": GameManager.user_id,
				"quizId": quizId,
				"knowledgeId": knowledgeId,
				"score": finalScore
			})
	# get attempts and golds from backend
	
	
func _update_status():
	HttpLayer._getStatus({
		"id": GameManager.user_id
	})
	
	
func http_completed(res, response_code, headers, route) -> void:
	if response_code == 200:
		if route == "submit":
			attempts = res['attempts']
			scoreDifference = res['scoreDifference']
			# update local data
			_update_status()
			# show score scene
			_show_score()
		elif route == "status":
			GameManager.statusList.clear()
			GameManager.quizStatus.clear()
			
			# save data to knowledge status list in GameManager
			for i in res['statusList'].size():
				GameManager.statusList.append(res['statusList'][i])	
				
			# save data to quiz status list in GameManager	
			for i in res['completeList'].size():
				GameManager.quizStatus.append(res['completeList'][i])	
				
			print(GameManager.statusList)
			print(GameManager.quizStatus)
	else:
		print("lesson not finished yet")
		return
		
	
func _show_score():
	optionsButtonContainer.visible = false
	questionLabel.visible = false
	navigationButtonContainer.visible = false
	exitButton.visible = false
	showScore.visible = true
	
	# show final score
	var scoreLabel = get_node("ShowScore/Score")
	scoreLabel.text = var_to_str(finalScore)
	
	# calculate gold bonus
	# TODO: 需要将金币增加数据传给map attributes
	if attempts == 1 :
		golds = finalScore
	else :
		if scoreDifference > 0 :
			golds = scoreDifference
		else:
			golds = 0
	var goldLabel = get_node("ShowScore/Gold")
	goldLabel.text = goldLabel.text + var_to_str(golds)
	
	#传到attributes
	GameManager.gold += golds
	#pushComponents()
	
	# attempts remaining
	var attemptsLabel = get_node("ShowScore/Attempts")
	attemptsLabel.text = attemptsLabel.text + var_to_str((3 - attempts) as int)
	
	# Try Again
	var tryAgainButton = get_node("ShowScore/TryAgainButton")
	if attempts == 3:
		tryAgainButton.disabled = true
	tryAgainButton.connect("pressed", _on_tryAgain_pressed)
	
	# Exit
	var ScoreExitButton = get_node("ShowScore/ExitButton")
	ScoreExitButton.connect("pressed", _on_exit_pressed)


func pushComponents():
	var _credential = {
			"gold": GameManager.gold,
			"prosperity": GameManager.prosperity,
			"construction_speed": GameManager.construction_speed,
			"id": GameManager.user_id,
	}
	HttpLayer._pushComponents(_credential);
	var s = preload("res://Components/components.tscn").instantiate()
	s._attributes_show()
	
	
func _on_tryAgain_pressed():
		get_tree().reload_current_scene()
		
	
func _on_exit_pressed():
	alertPopup.visible = true;
	alertPopup.get_ok_button().connect("pressed", _popup_exit)
	cancelButton.connect("pressed", _popup_hide)
	
	
func _popup_exit():
	get_tree().change_scene_to_file("res://LearningPage/learning_scene.tscn")
	

func _popup_hide():
	alertPopup.visible = false;

	
# calculate final score
func _calcu_score():
	var score = 0
	var eachScore = 100 / questionSize
	
	for i in range(questionSize):
		var flag = true
		print(answerArray[i], selectedArray[i])
		for j in range(answerArray[i].size()):
			if selectedArray[i] == null || selectedArray[i][j] == null:
				flag = false
				break
			elif answerArray[i][j] != selectedArray[i][j]:
				flag = false
				break
		if flag == true:
			score = score + eachScore
			
	finalScore = score
	print(finalScore)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# when last question, hide 'NEXT' and show 'SUBMIT'
	if currentQuestionIndex == quizData.questions.size() - 1:
		submitButton.visible = true
		nextButton.visible = false
	elif currentQuestionIndex == 0:
		previousButton.visible = false
	else:
		submitButton.visible = false
		nextButton.visible = true
		previousButton.visible = true
		

	
	

