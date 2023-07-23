extends Node

var user_id = null
var other_id = null

var user_token = null
var user_data = null
var save_data = null

#Main Attributes: prosperity\coins\speed...etc

#Reading
var statusList = [0,0,0,0,0]
var reading_path = ""

#Quiz
var quizStatus = []
var question_path = ""

#TileMap
enum BuildingType { 
	blank = -1,
	residential_building_1 = 0, 
	supermarket_1 = 1, 
	bank_1 = 2, 
	farm_1 = 3, 
	constrction_site_1 = 4,
	hospital_1 = 5,
	residential_building_2 = 10, 
	supermarket_2 = 11, 
	bank_2 = 12, 
	farm_2 = 13, 
	#constrction_site_2 = 14,
	hospital_2 = 15,
	residential_building_3 = 20, 
	supermarket_3 = 21, 
	bank_3 = 22, 
	farm_3 = 23, 
	#constrction_site_3 = 24,
	hospital_3 = 25
	}
var buildings_data = []
var gold = 0
var prosperity = 0
var construction_speed = 0
var mapDict = {} # 储存房子建在哪个cell上，需要读写后端

#Setting
var music_volume = 0.7
var sound_volume = 0.7

#Components
var population:int = 1000
var rank = 33

func _ready():
	var file = FileAccess.open("res://XufengPart/BuildingType.json", FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	#if not parse_result == OK:
		#print("JSON Parse Error: ", json.get_error_message(), " in ", json_text, " at line ", json.get_error_line())
	var BuildingJsonData = json.get_data()
	buildings_data = BuildingJsonData["buildings"]

	
	set_volume()
	
	# 调试房屋升级，不想要就删掉，construction site目前还没做
	mapDict[Vector2i(15,1)] = 0
	mapDict[Vector2i(15,5)] = 10
	mapDict[Vector2i(15,3)] = 1
	mapDict[Vector2i(16,3)] = -1
	mapDict[Vector2i(15,-2)] = 2
	mapDict[Vector2i(16,-2)] = -1
	mapDict[Vector2i(15,-1)] = -1
	mapDict[Vector2i(16,-1)] = -1
	mapDict[Vector2i(15,5)] = 3
	mapDict[Vector2i(16,5)] = -1
	mapDict[Vector2i(15,7)] = 5
	mapDict[Vector2i(16,7)] = -1


# initialize the volume of music and sound effect
func set_volume():
	AudioServer.set_bus_volume_db(0, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(1, linear_to_db(sound_volume))
