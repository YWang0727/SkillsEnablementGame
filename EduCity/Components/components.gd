extends Node

@onready var attributes : Node = get_node("attributes")
# index
#gold 0 1 
#prosperity  2 3 
#speed  4 5
#population  6 7 

# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.http_completed.connect(http_completed)
	HttpLayer._getComponents()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gold_pressed():
	get_tree().change_scene_to_file("res://LearningPage/learning_scene.tscn")


func http_completed(res, response_code, headers, route):
	if route == "getComponents":
		GameManager.gold = res.gold
		GameManager.prosperity = res.prosperity
		GameManager.construction_speed = res.construction_speed
		GameManager.population = GameManager.gold + GameManager.prosperity + GameManager.construction_speed
		_attributes_show()
	

func _attributes_show():
	attributes.set_item_text(1,str(GameManager.gold))
	attributes.set_item_text(3,str(GameManager.prosperity))
	attributes.set_item_text(5,str(GameManager.construction_speed))
	attributes.set_item_text(7,str(GameManager.construction_speed))
	

func pushComponents():
	var _credential = {
			"gold": GameManager.gold,
			"prosperity": GameManager.prosperity,
			"construction_speed": GameManager.construction_speed,
			"id": GameManager.user_id,
	}
	HttpLayer._pushComponents(_credential);


#写一个触发器,一旦建房子/升级房子/完成quiz-------先存入数据库,再显示出来
#目前只有建房子
func _on_tile_map_store_components():
	pushComponents();
	_attributes_show();
	pass # Replace with function body.


func _on_bt_leader_board_pressed():
	var s = preload("res://Leaderboard/leaderboard.tscn").instantiate()
	add_child(s)
	pass # Replace with function body.


func _on_tile_map_attributes_show_2():
	_attributes_show();
	pass # Replace with function body.




