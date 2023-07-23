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
	if route == "leaderBoard":
		var itemList = get_node("ColorRect/ItemList")
		get_node("ColorRect/my-info/myCityName").text = res.name
		get_node("ColorRect/my-info/myProsperity").text = str(res.prosperity)
		total_num = res.total_num
		for i in range(1, total_num + 1):
			itemList.add_item(str(i))
			itemList.add_item(res.all_name[i - 1])
			itemList.add_item(str(res.all_prosperity[i - 1]))
			itemList.add_item("map")
			#map项存 mapid 值
			var index = (i - 1) * 4 + 3
			itemList.set_item_metadata(index,res.all_id[i - 1])
			if res.all_name[i - 1] == res.name and res.all_prosperity[i - 1] == res.prosperity:
				get_node("ColorRect/my-info/myRank").text = str(i)
				GameManager.rank = i
				itemList.set_item_custom_bg_color((i - 1) * 4, Color(0, 0, 0, 1))
				itemList.set_item_custom_bg_color((i - 1) * 4 + 1, Color(0, 0, 0, 1))
				itemList.set_item_custom_bg_color((i - 1) * 4 + 2, Color(0, 0, 0, 1))
				itemList.set_item_custom_bg_color((i - 1) * 4 + 3, Color(0, 0, 0, 1))
	



func _on_item_list_item_activated(index):
	if index % 4 == 3:
		GameManager.other_id = get_node("ColorRect/ItemList").get_item_metadata(index)
		GameManager.other_city_name = get_node("ColorRect/ItemList").get_item_text(index - 3)
		GameManager.other_prosperity = get_node("ColorRect/ItemList").get_item_text(index - 2)
		GameManager.other_rank = get_node("ColorRect/ItemList").get_item_text(index - 1)
		get_tree().change_scene_to_file("res://Leaderboard/OtherMap.tscn")
	


func _on_self_check_pressed():
	var itemList = get_node("ColorRect/ItemList")
	itemList.select((GameManager.rank - 1) * 4)
	itemList.ensure_current_is_visible()
	pass # Replace with function body.
