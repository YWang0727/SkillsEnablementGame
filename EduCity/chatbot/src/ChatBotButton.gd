extends Button

var chat_room_scene = preload("res://chatbot/src/chatbot.tscn")

func _on_chat_bot_pressed():
	var chat_room = chat_room_scene.instantiate()
	if (!get_parent().has_node("chatbot")):
		get_parent().add_child(chat_room)
	chat_room.visible = true
