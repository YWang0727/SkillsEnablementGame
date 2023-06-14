extends CanvasLayer

var currentQuestionIndex := 0
var quizData := {}
var nextButton := Button.new()
var previousButton := Button.new()
var submitButton := Button.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_questions_from_json(GameManager.question_path)
	
	# create question node
	var questionLabel  = get_node("QuestionLabel")
	
	#create option button node
	var optionsButtonContainer = get_node("OptionsButtonContainer")
	
	#create navigation botton node
	var navigationButtonContainer = get_node("NavigationButtonContainer")
	nextButton.text = "NEXT"
	nextButton.visible = true
	nextButton.size.x = 200
	nextButton.size.y = 60
	nextButton.connect("pressed",_on_next_button_pressed)
	navigationButtonContainer.add_child(nextButton)
	
	previousButton.text = "PREVIOUS"
	previousButton.visible = true
	previousButton.size.x = 200
	previousButton.size.y = 60
	previousButton.connect("pressed",_on_previous_button_pressed)
	navigationButtonContainer.add_child(previousButton)
	
	#create submit button node
	submitButton.text = "submit"
	submitButton.visible = false
	submitButton.size.x = 200
	submitButton.size.y = 60
	submitButton.connect("pressed",_on_submit_button_pressed)
	navigationButtonContainer.add_child(submitButton)
	
	# show the first question
	show_question(currentQuestionIndex)
	
	
func load_questions_from_json(file_path: String) -> void:
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

	else:
		print("File doesn't exist!")
		
		
func show_question(index: int):
	if index < 0 or index >= quizData.questions.size():
		return

	var question: Dictionary = quizData.questions[index]

	var questionLabel := get_node("QuestionLabel") as Label
	questionLabel.text = question["question"]

	var optionsButtonContainer := get_node("OptionsButtonContainer") as VBoxContainer
	clearContainer(optionsButtonContainer)

	for optionIndex in question.options.size():
		var option = question.options[optionIndex]

		var button := Button.new()
		button.text = option
		button.custom_minimum_size.x = 200
		button.custom_minimum_size.y = 70
		button.pressed.connect(_on_option_button_pressed.bind(index, optionIndex))
		optionsButtonContainer.add_child(button)


func clearContainer(container: Node):
	while container.get_child_count() > 0:
		var child := container.get_child(0)
		container.remove_child(child)
		child.queue_free()


func _on_next_button_pressed():
	currentQuestionIndex + 1
	#TODO
	
	
func _on_previous_button_pressed():
	currentQuestionIndex - 1
	#TODO
		

func _on_option_button_pressed(questionIndex: int, optionIndex: int):
	# 处理选择选项的逻辑
	var selectedOption = quizData.questions[questionIndex].options[optionIndex]
	print("selected：" + selectedOption)


func _on_submit_button_pressed():
	# 处理提交按钮的逻辑
	print("submit success")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentQuestionIndex == quizData.questions.size() - 1:
		submitButton.visible = true
		nextButton.visible = false
		#显示submit按钮 隐藏next按钮
	elif currentQuestionIndex == 0:
		previousButton.visible = false

