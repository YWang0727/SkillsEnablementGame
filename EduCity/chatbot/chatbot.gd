extends CanvasLayer

var alert: Popup
var messageInput

# Called when the node enters the scene tree for the first time.
func _ready():
	initiate_variales()
	connect_signals()
	pass # Replace with function body.

func initiate_variales():
	alert = get_node("Alert")
	messageInput = get_node("Control/VBoxContainer/ColorRect2/TextEdit")

func connect_signals():
	HttpLayer.http_completed.connect(http_completed)


func http_completed(res, response_code, headers, route):
	if (response_code == 200):
		print(res.msg)
		# check if code in resultVO is 0000(SUCCESS)
		if (res.code != 0):
			alert.set_message(res.data)
			alert.popup_centered()
			return
			
		send_message()
			
	else:
		print("Fail to send message to Watson assistant")


func send_message():
	HttpLayer.send_message({
		"message": "",
		"sessionId": "",
		"isNewSession": ""
	})
