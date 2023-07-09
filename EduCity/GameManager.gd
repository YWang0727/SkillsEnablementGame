extends Node

var user_id = 1

var user_token = null
var user_data = null
var save_data = null

#Main Attributes: prosperity\coins\speed...etc

#Reading
var statusList = []
var reading_path = ""

#Quiz
var quizStatus = []
var question_path = ""

#TileMap
enum BuildingType { residential_building_1, supermarket_1, bank_1, farm_1, constrction_site_1, hospital_1}
var buildings_data = []
var gold = 0
var prosperity = 0
var construction_speed = 0

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

