extends Button

signal attributes_show

@onready var tileMap : Node = get_parent()
@onready var tileSet: TileSet = tileMap.get_tileset()
var buildingID
var updateCellPos

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mousePos = get_global_mouse_position() - Vector2(tileMap.position.x, tileMap.position.y)
		updateCellPos = tileMap.local_to_map(mousePos)
		buildingID = _getBuildingID(updateCellPos)
		if tileMap.selectedBuildingType == -1 and buildingID != -1 and buildingID < 20:
				_setButtonPosition(updateCellPos, buildingID)
				_setLableText(buildingID)
				self.show()
		else:
			self.hide()
	pass


func _setButtonPosition(updateCellPos, buildingID) -> void:
	var tilePos = tileMap.map_to_local(updateCellPos)
	var tileSize = tileSet.get_source(buildingID).texture_region_size # Get building picture size
	var cellsCount = tileMap._getCellsCount(buildingID)
	match cellsCount:
		1:
			self.position = tilePos - Vector2(24,tileSize.y/2+54)
		2:
			self.position = tilePos - Vector2(-8,tileSize.y)
		4:
			self.position = tilePos - Vector2(25,tileSize.y-28)


func _setLableText(buildingID) -> void:
	var str
	var building_data = getBuildingDataByID(buildingID+10)
	str = "Update to " + building_data["name"] + "\n"
	str += "Cost: " + str(building_data["cost"]) + " golds" + "\n"
	str += "Prosperity: +" + str(building_data["prosperity"]) + "\n"
	if building_data["money"] != 0:
		str += "Earn Gold: +" + str(building_data["money"]) + " golds per day" + "\n"
	var updateLable = get_child(0)
	updateLable.text = str


func _on_pressed():
	buildingID = buildingID + 10
	var building_data = getBuildingDataByID(buildingID)
	var cost = building_data["cost"]
	var prosperity = building_data["prosperity"]
	if GameManager.gold >= cost:
		GameManager.gold -= cost
		GameManager.prosperity += prosperity
		if buildingID == GameManager.BuildingType.constrction_site_1 or\
		buildingID == GameManager.BuildingType.constrction_site_2 or\
		buildingID == GameManager.BuildingType.constrction_site_3:
			if GameManager.construction_speed < 6:
				GameManager.construction_speed += 1
		
		tileMap._drawInBuildingCellsLabel(buildingID,updateCellPos)
		levelUp(buildingID)
		pushComponents()
	else :
		var error_pannel = get_node("/root/MainScene/ErrorPannel")
		error_pannel.popup_centered()
	self.hide()


func _getBuildingID(targetCellPos) -> int:
	var targetRow
	var found = false
	for row in tileMap.cellPosArray2D:
		if found:
			break
		for cellPos in row:
			if cellPos == targetCellPos:
				targetRow = row
				found = true
				break
	if found:
		updateCellPos = targetRow[0]
		for cellPos in targetRow:
			if GameManager.mapDict.has(cellPos):
				return GameManager.mapDict[cellPos]["house_type"]
	return -1


func getBuildingDataByID(id:int) -> Dictionary:
	for building_data in GameManager.buildings_data:
		if building_data["tileID"] == id:
			return building_data
	return {}


#---------------------------------------------------------------------------
#---------------------------------HTTPLAYER---------------------------------
#---------------------------------------------------------------------------

func pushComponents():
	var _credential = {
			"gold": GameManager.gold,
			"prosperity": GameManager.prosperity,
			"construction_speed": GameManager.construction_speed,
			"id": GameManager.user_id,
	}
	HttpLayer._pushComponents(_credential);
	emit_signal("attributes_show")


func levelUp(buildingID):
	var buildHours = (24 - (GameManager.construction_speed - 1) * 4) / 2
	var nowTimestamp:int = Time.get_unix_time_from_system()
	#var finishTime = nowTimestamp + buildHours * 3600
	var finishTime = nowTimestamp + buildHours # 用于测试，单位为秒
	var _credential = {
			"x": updateCellPos.x,
			"y": updateCellPos.y,
			"houseType": buildingID,
			"id": GameManager.user_id,
			"finishTime": finishTime
	}
	HttpLayer._levelUp(_credential)
	# update GameManager
	GameManager.mapDict[updateCellPos]["finish_time"] = finishTime
	GameManager.mapDict[updateCellPos]["house_type"] = buildingID
