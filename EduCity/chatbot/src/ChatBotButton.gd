extends Button

var chat_room = preload("res://chatbot/src/chatbot.tscn").instantiate()

func _on_chat_bot_pressed():
	if (!get_parent().has_node("chatbot")):
		add_child(chat_room)
	chat_room.visible = true
