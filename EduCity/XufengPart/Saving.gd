extends Node

var mapDict = GameManager.mapDict
var takenmapcell = []

@onready var timer = get_node("/root/GlobalTimer")


# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.connect("http_completed", http_completed)
	
		
# read the map
func get_takenmapcell():
	for i in mapDict:
		takenmapcell.append({
			"x": i.x,
			"y": i.y,
			"houseType": mapDict[i]
		})


func save_auto():
	get_takenmapcell()
	
	var _credential = {
			"id": GameManager.user_id,
			"cityid": GameManager.user_data["cityMap"],
			"gold": GameManager.gold,
			"prosperity": GameManager.prosperity,
			"construction_speed": GameManager.construction_speed,
			
			"takenmapcell": takenmapcell
	}
	HttpLayer._save_auto(_credential);
	
	
func save():
	get_takenmapcell()
	
	var _credential = {
			"id": GameManager.user_id,
			"cityid": GameManager.user_data["cityMap"],
			
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
	if route == "save" || route == "save_auto":
		if route == "save" && response_code == 200 :
				print("saved successfully")
				AlertPopup.setPosition(0,0,'center')
				AlertPopup.show_error_message("Saved successfully!")
				AlertPopup.title = ""
				timer.start(10.0)
		elif route == "save_auto" && response_code == 200 :
				print("saved successfully")
				timer.start(10.0)
		else :
			print("Failed to save")
			AlertPopup.setPosition(0,0,'center')
			AlertPopup.show_error_message("Failed to save, please try again later")
	
	
