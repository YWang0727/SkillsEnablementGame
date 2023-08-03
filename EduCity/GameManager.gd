extends Node

var user_id = null

#city id
var other_id = null
var other_city_name = null
var other_prosperity = null
var other_rank = null

var user_token = null
var user_data = null
var save_data = null
var user_loginTime = null

#Main Attributes: prosperity\coins\speed...etc

#Reading
var statusList = [2,2,2,2,2]
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
	constrction_site_2 = 14,
	hospital_2 = 15,
	residential_building_3 = 20, 
	supermarket_3 = 21, 
	bank_3 = 22, 
	farm_3 = 23, 
	constrction_site_3 = 24,
	hospital_3 = 25
	}
var buildings_data = []
var gold = 9999
var prosperity = 0
var construction_speed = 1
var mapDict = {} # key: cell position, value: {"house_type":int, "finish_time":string}

# Setting
var music_volume = 0.7
var sound_volume = 0.7
var property_data = {}

#Components
var population:int = 1000
var rank = 33

# Chatbot
var chat_history = {}

func _ready():
	var file = FileAccess.open("res://XufengPart/BuildingType.json", FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	var BuildingJsonData = json.get_data()
	buildings_data = BuildingJsonData["buildings"]

	set_volume()
	initPropertyData()
	initChatHistory()



# initialize the volume of music and sound effect
func set_volume():
	AudioServer.set_bus_volume_db(0, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(1, linear_to_db(sound_volume))


func initPropertyData():
	property_data = {
		"residentialBuilding": "",
		"bank": "",
		"supermarket": "",
		"hospital": "",
		"farm": "",
		"constructionSite": ""
	}

# messages array will contain arrow, contents and options
func initChatHistory():
	chat_history= {
		"sessionId": "",
		"isNewSession": true,
		"messages": []
	}
	
