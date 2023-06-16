extends CanvasLayer

var currentQuestionIndex := 0
var questionSize := 0
var quizData := {}

# init compons
var questionLabel := Label.new()
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
var finalScore = 0.00

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_questions_from_json(GameManager.question_path)
	
	# create question node
	questionLabel  = get_node("QuestionLabel")
	
	optionsButtonContainer = get_node("OptionsButtonContainer")
	
	#create navigation botton node
	navigationButtonContainer = get_node("NavigationButtonContainer")
	previousButton.text = "PREV"
	previousButton.visible = true
	previousButton.custom_minimum_size.x = 70
	previousButton.custom_minimum_size.y = 70
	previousButton.connect("pressed",_on_previous_button_pressed)
	navigationButtonContainer.add_child(previousButton)
	
	nextButton.text = "NEXT"
	nextButton.visible = true
	nextButton.custom_minimum_size.x = 70
	nextButton.custom_minimum_size.y = 70
	nextButton.connect("pressed",_on_next_button_pressed)
	navigationButtonContainer.add_child(nextButton)
	
	#create submit button node
	submitButton.text = "SUBMIT"
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
	# if is multi-answers or not
	var multi = false
	if answerArray[index].size() > 1:
		multi = true
		
	if index < 0 or index >= questionSize:
		return

	var question: Dictionary = quizData.questions[index]
	# show current question
	var questionLabel := get_node("QuestionLabel") as Label
	questionLabel.text = var_to_str(index + 1) + ". " + question["question"]

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
	new_stylebox_normal.bg_color = Color("4f00ed")
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
	# TODO：存储提交次数到数据库！！！
	print("submit success")
	_calcu_score()
	_show_score()
	
	
func _show_score():
	# TODO: 金币结算 ！！！
	optionsButtonContainer.visible = false
	questionLabel.visible = false
	navigationButtonContainer.visible = false
	exitButton.visible = false
	showScore.visible = true
	
	# show final score
	var scoreLabel = get_node("ShowScore/Score")
	scoreLabel.text = var_to_str(finalScore)
	
	# attempts remaining
	var attemptsLabel = get_node("ShowScore/Attempts")
	# TODO:从数据库获取提交次数！！！
	attemptsLabel.text = attemptsLabel.text + var_to_str(1) # test data need to be replaced
	
	# Try Again
	var tryAgainButton = get_node("ShowScore/TryAgainButton")
	tryAgainButton.connect("pressed", _on_tryAgain_pressed)
	
	# Exit
	var ScoreExitButton = get_node("ShowScore/ExitButton")
	ScoreExitButton.connect("pressed", _on_exit_pressed)
	
	
func _on_tryAgain_pressed():
	get_tree().reload_current_scene()
	
	
func _on_exit_pressed():
	get_tree().change_scene_to_file("res://learning_scene.tscn")

	
# calculate final score
func _calcu_score():
	var score = 0.00
	var eachScore = snapped(100.00 / questionSize, 0.01)
	
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
		

	
	

