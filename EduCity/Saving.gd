extends Node

var mapDict = GameManager.mapDict
var takenmapcell = []
var saveInProgressLabel = Label.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.connect("http_completed", http_completed)
	
	#saveInProgressLabel = get_node("SaveInProgressLabel")
	#saveInProgressLabel.text = "Saving ..."
	#saveInProgressLabel.visible = false
	
	
# read the map
func get_takenmapcell():
	for i in mapDict:
		takenmapcell.append({
			"x": i.x,
			"y": i.y,
			"houseType": mapDict[i]
		})


func save():
	#saveInProgressLabel.visible = true
	
	get_takenmapcell()
	
	var _credential = {
			"id": GameManager.user_id,
			"cityid": GameManager.user_data["citymap"],
			
			"gold": GameManager.gold,
			"prosperity": GameManager.prosperity,
			"construction_speed": GameManager.construction_speed,
			
			"takenmapcell": takenmapcell
	}
	HttpLayer._save(_credential);
	
	
func http_completed(res, response_code, headers, route) -> void:
	#if token is checked and valid, return true
	if !AlertPopup.tokenCheck(res):
		return	
	if response_code == 200 && route == "save":
		print("saved successfully")
		#saveInProgressLabel.visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
