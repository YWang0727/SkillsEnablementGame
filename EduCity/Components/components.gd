extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.http_completed.connect(http_completed)
	HttpLayer._components()

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_prosperity_pressed():
	var s = preload("res://Leaderboard/leaderboard.tscn").instantiate()
	add_child(s)

func _on_gold_pressed():
	get_tree().change_scene_to_file("res://LearningPage/learning_scene.tscn")


func http_completed(res, response_code, headers, route):
	if route == "components":
		GameManager.gold = res.gold
		GameManager.prosperity = res.prosperity
		GameManager.construction_speed = res.construction_speed
		_components_show()


func _components_show():
	get_node("Gold").text = "Gold              :  $" + str(GameManager.gold)
	get_node("Prosperity").text =  "Prosperity    :  " + str(GameManager.prosperity)
	get_node("Build_Speed").text = "Build Speed  :  " + str(GameManager.construction_speed)
