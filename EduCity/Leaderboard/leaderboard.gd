extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.connect("http_completed", http_completed)
	HttpLayer._leaderBoard()
	pass # Replace with function body.

func _process(delta):
	pass


func _on_button_pressed():
	queue_free()



func http_completed(res, response_code, headers, route):
	get_node("ColorRect/Label2").text = res.name
	get_node("ColorRect/Label4").text = str(res.prosperity)
	
	
