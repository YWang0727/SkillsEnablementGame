extends Node


var total_num = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.connect("http_completed", http_completed)
	HttpLayer._leaderBoard()
	

func _process(delta):
	pass


func _on_button_pressed():
	queue_free()


func http_completed(res, response_code, headers, route):
	get_node("ColorRect/my-info/myCityName").text = res.name
	get_node("ColorRect/my-info/myProsperity").text = str(res.prosperity)
	total_num = res.total_num
	
	for i in range(1, total_num + 1):
		get_node("ColorRect/ItemList").add_item(str(i))
		get_node("ColorRect/ItemList").add_item(res.all_name[i - 1])
		get_node("ColorRect/ItemList").add_item(str(res.all_prosperity[i - 1]))
		get_node("ColorRect/ItemList").add_item("map")
		if res.all_name[i - 1] == res.name and res.all_prosperity[i - 1] == res.prosperity:
			get_node("ColorRect/my-info/myRank").text = str(i)
			get_node("ColorRect/ItemList").set_item_custom_bg_color((i - 1) * 4, Color(0, 0, 0, 1))
			get_node("ColorRect/ItemList").set_item_custom_bg_color((i - 1) * 4 + 1, Color(0, 0, 0, 1))
			get_node("ColorRect/ItemList").set_item_custom_bg_color((i - 1) * 4 + 2, Color(0, 0, 0, 1))
			get_node("ColorRect/ItemList").set_item_custom_bg_color((i - 1) * 4 + 3, Color(0, 0, 0, 1))

