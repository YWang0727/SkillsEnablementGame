extends Node2D

var quizId = null
var knowledgeId = null
var quizConfig = {}

var richTextLabel = RichTextLabel.new()
var exitButton = Button.new()
var completedButton = Button.new()
var scrollContainer = ScrollContainer.new()
var vScrollbar = VScrollBar.new()

#var isScrollingToBottom: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.connect("http_completed", http_completed)
		
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
		
		if quizConfig.has(GameManager.reading_path):
			return var_to_str(quizConfig[GameManager.reading_path])
		else:
			print("Quiz ID not found for file:", file_path)
			return -1
	else:
		print("File doesn't exist!")


func _on_completedButton_clicked():
	quizId = str_to_var(_get_quizId("user://quizConfig.json").substr(1,1))
	knowledgeId = str_to_var(_get_quizId("user://quizConfig.json").substr(0,1))
	
	# store complete status to database
	HttpLayer._completeLesson({
				"id": GameManager.user_id,
				"knowledgeId": knowledgeId,
				"quizId": quizId,
			})
	
	
func _update_status():
	HttpLayer._getStatus({
		"id": GameManager.user_id
	})
	
	
func http_completed(res, response_code, headers, route) -> void:
	#if token is checked and valid, return true
	if !AlertPopup.tokenCheck(res):
		return	
		
	if response_code == 200 && route == "complete":
		print("success")
		# update local data
		_update_status()
		
	elif response_code == 200 && route == "status":
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
		
		get_tree().change_scene_to_file("res://LearningPage/learning_scene.tscn")
	
	
#func _scroll_to_bottom(value: float):
#	print("111")
#	if isScrollingToBottom and value >= vScrollbar.max_value:
#		completedButton.visible = true
		
	
func _on_exitButton_pressed():
	get_tree().change_scene_to_file("res://LearningPage/learning_scene.tscn")
	
	
func _richtextlabel_on_meta_clicked(meta):
	OS.shell_open(str(meta))
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	_scroll_to_bottom()
