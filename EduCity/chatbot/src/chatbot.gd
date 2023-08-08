extends CanvasLayer

var bubbleScene = preload("res://chatbot/src/bubble.tscn")

var alert: Popup
var messageInput: TextEdit
var bubbles: Control
var scrollContainer: ScrollContainer
var sendButton: Button
var exitButton: Button
var newSession: Button
var bubbleSound: AudioStreamPlayer2D
var sendSound: AudioStreamPlayer2D
var cancelSound: AudioStreamPlayer2D
var clearSound: AudioStreamPlayer2D

var optionNum: int = 0
var scroll_vertical_size = 0
var pre_scroll_vertical_size = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initiate_variales()
	connect_signals()
	
	load_chat_history()

# load chat history into chat room
func load_chat_history():
	var messages: Array = GameManager.chat_history.messages
	# get welcome massage the first opening the chatbot
	if (messages.is_empty()):
		send_message("")
		return
		
	for message in messages:
		for content in message.contents:
			add_bubble(content, message.arrow)
		for option in message.options:
			add_bubble(option, "none")

func _process(delta):
	var count = bubbles.get_child_count()
	# set position of every bubble
	for i in count:
		if (i > 0):
			bubbles.get_child(i).position.y = bubbles.get_child(i - 1).position.y + bubbles.get_child(i - 1).size.y
	# ser size of content in scrollContainer
	if (count != 0):
		bubbles.custom_minimum_size.y = bubbles.get_child(count - 1).position.y + bubbles.get_child(count - 1).size.y
		scroll_vertical_size = bubbles.custom_minimum_size.y - scrollContainer.size.y
		
	# show the latest message
	# sometimes it's not working
	if (scroll_vertical_size > pre_scroll_vertical_size):
		pre_scroll_vertical_size = scroll_vertical_size
		scrollContainer.scroll_vertical = pre_scroll_vertical_size
		

func initiate_variales():
	alert = get_node("Alert")
	messageInput = get_node("Panel/VBoxContainer/Message/HBoxContainer/Input")
	sendButton = get_node("Panel/VBoxContainer/Message/HBoxContainer/Send")
	bubbles = get_node("Panel/VBoxContainer/ScrollContainer/Bubbles")
	scrollContainer = get_node("Panel/VBoxContainer/ScrollContainer")
	exitButton = get_node("Panel/VBoxContainer/Head/HBoxContainer/Exit")
	newSession = get_node("Panel/VBoxContainer/Head/HBoxContainer/NewSession")
	bubbleSound = get_node("BubbleSound")
	sendSound = get_node("SendSound")
	cancelSound = get_node("CancelSound")
	clearSound = get_node("ClearSound")
	
	newSession.focus_mode = Control.FOCUS_NONE

func connect_signals():
	HttpLayer.http_completed.connect(http_completed)
	sendButton.pressed.connect(send_button_pressed)
	exitButton.pressed.connect(exit_button_presssed)
	newSession.pressed.connect(new_session_button_presssed)

func _input(event: InputEvent):
	if (event.is_action_pressed("ui_text_submit")):
		send_button_pressed()
		get_viewport().set_input_as_handled()

func exit_button_presssed():
	cancelSound.play()
	self.visible = false

# create a new session window
func new_session_button_presssed():
	clearSound.play()
	
	# disable new session button
	newSession.disabled = true
	# clear chat history
	GameManager.chat_history.messages = [] 
	GameManager.chat_history.isNewSession = true
	GameManager.chat_history.sessionId = ""
	# clear bubbles
	var childs_num = bubbles.get_child_count()
	print(childs_num)
	while childs_num > 0:
		bubbles.get_child(childs_num - 1).free()
		childs_num = childs_num - 1
	
	# get the welcome message
	send_message("")

# process the messages sent by user
func send_button_pressed():
	# play sound
	sendSound.play()
	
	add_bubble(messageInput.text, "right")
	store_chat_history([messageInput.text], "right")
	send_message(messageInput.text)
	messageInput.text = ""

# add bubble in bubbles scroller
func add_bubble(message: String, arrow: String, clickable: bool = false):
	# play bubble sound if it's from chatbot
	if (arrow == "left" || arrow == "none"):
		bubbleSound.play()
	
	var bubble = bubbleScene.instantiate()
	bubble.message = message
	bubble.arrow = arrow
	bubble.clickable = clickable
	
	bubbles.add_child(bubble)
	bubble.option_selected.connect(option_selected)
	# set the position of right bubble to the right side
	if (bubble.arrow == "right"):
		bubble.position.x = bubble.get_parent().position.x + bubble.get_parent().size.x - bubble.size.x


# when user select one option, send it to server
func option_selected(bubble):
	# disable all the options
	var bubbleNum = bubbles.get_child_count()
	for i in optionNum:
		bubbles.get_child(bubbleNum - i - 1).clickable = false
	
	# send the text in selected option
	add_bubble(bubble.message, "right")
	store_chat_history([bubble.message], "right")
	send_message(bubble.message)

# send message to server
func send_message(message: String):
	HttpLayer.send_message({
		"messages":[message],
		"sessionId": GameManager.chat_history.sessionId,
		"isNewSession": GameManager.chat_history.isNewSession
	})

# store messages in GameManager
func store_chat_history(contents: Array, arrow, options = []):
	GameManager.chat_history.messages.append({
		"arrow": arrow,
		"contents": contents,
		"options": options
	})


func http_completed(res, response_code, headers, route):
	#if token is checked and valid, return true
	if !AlertPopup.tokenCheck(res):
		return
	
	if (route != 'message'):
		return
		
	if (response_code == 200):
		print(res.msg)
		# check if code in resultVO is 0000(SUCCESS)
		if (res.code != 0):
			alert.set_message(res.data)
			alert.popup_centered()
			return
		
		# add messaage and option bubbles from watson
		for message in res.data.messages:
			add_bubble(message, "left")
		for option in res.data.options:
			add_bubble(option, "none", true)
		optionNum = res.data.options.size()
		# update chat history in GameManager
		store_chat_history(res.data.messages, "left", res.data.options)
		GameManager.chat_history.sessionId = res.data.sessionId
		GameManager.chat_history.isNewSession = res.data.isNewSession
		
		newSession.disabled = false
	
	else:
		print("Fail to send message to Watson assistant")
