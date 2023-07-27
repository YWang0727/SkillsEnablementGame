extends CanvasLayer

var bubbleScene = preload("res://chatbot/src/bubble.tscn")

var alert: Popup
var messageInput: TextEdit
var bubbles: Control
var sendButton: Button
var exitButton: Button
var newSession: Button

# Called when the node enters the scene tree for the first time.
func _ready():
	initiate_variales()
	connect_signals()
	
	load_chat_history()

# load chat history into chat room
func load_chat_history():
	var messageArray: Array = GameManager.chat_history.messages
	# get welcome massage the first opening the chatbot
	if (messageArray.is_empty()):
		send_message("")
	for message in messageArray:
		add_bubble(message.content, message.sender == "robot")

func _process(delta):
	var count = bubbles.get_child_count()
	# set position of every bubble
	for i in count:
		if (i > 0):
			bubbles.get_child(i).position.y = bubbles.get_child(i - 1).position.y + bubbles.get_child(i - 1).size.y
	# ser size of content in scrollContainer
	if (count != 0):
		bubbles.custom_minimum_size.y = bubbles.get_child(count - 1).position.y + bubbles.get_child(count - 1).size.y

func initiate_variales():
	alert = get_node("Alert")
	messageInput = get_node("Control/VBoxContainer/Message/Input")
	sendButton = get_node("Control/VBoxContainer/Message/Send")
	bubbles = get_node("Control/VBoxContainer/ScrollContainer/Bubbles")
	exitButton = get_node("Control/VBoxContainer/Head/Exit")
	newSession = get_node("Control/VBoxContainer/Head/NewSession")

func connect_signals():
	HttpLayer.http_completed.connect(http_completed)
	sendButton.pressed.connect(send_button_pressed)
	exitButton.pressed.connect(exit_button_presssed)
	newSession.pressed.connect(new_session_button_presssed)

func exit_button_presssed():
	self.visible = false

# clear chat history
func new_session_button_presssed():
	GameManager.chat_history.messages = []
	GameManager.isNewSession = true
	GameManager.sessionId = ""
	# get the welcome message
	send_message("")

# process the messages sent by user
func send_button_pressed():
	add_bubble(messageInput.text, false)
	store_chat_history(messageInput.text, "user")
	
	send_message(messageInput.text)
	messageInput.text = ""

# add bubble in bubbles scroller
func add_bubble(message: String, direction: bool):
	var bubble = bubbleScene.instantiate()
	bubble.message = message
	bubbles.add_child(bubble)
	
	# set the direction of bubble
	bubble.arrowDirection = direction
	if (!bubble.arrowDirection):
		bubble.position.x = bubble.get_parent().position.x + bubble.get_parent().size.x - bubble.size.x

# send message to server
func send_message(message: String):
	HttpLayer.send_message({
		"message": message,
		"sessionId": GameManager.chat_history.sessionId,
		"isNewSession": GameManager.chat_history.isNewSession
	})

# store messages in GameManager
func store_chat_history(message: String, sender: String):
	GameManager.chat_history.messages.append({
		"sender": sender,
		"content": message
	})


func http_completed(res, response_code, headers, route):
	if (response_code == 200):
		print(res.msg)
		# check if code in resultVO is 0000(SUCCESS)
		if (res.code != 0):
			alert.set_message(res.data)
			alert.popup_centered()
			return
			
		if (route == "message"):
			add_bubble(res.data.message, true)
			# update chatbot data in GameManager
			store_chat_history(res.data.message, "robot")
			GameManager.chat_history.sessionId = res.data.sessionId
			GameManager.chat_history.isNewSession = res.data.isNewSession
	else:
		print("Fail to send message to Watson assistant")
