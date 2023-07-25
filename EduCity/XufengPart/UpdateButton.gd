extends Button

signal attributes_show

@onready var tileMap : Node = get_parent()
@onready var tileSet: TileSet = tileMap.get_tileset()
var buildingID
var updateCellPos

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mousePos = get_global_mouse_position() - Vector2(tileMap.position.x, tileMap.position.y)
		updateCellPos = tileMap.local_to_map(mousePos)
		if GameManager.mapDict.has(updateCellPos):
			buildingID = GameManager.mapDict[updateCellPos]
			if buildingID != GameManager.BuildingType.blank and buildingID < 20:
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
	for building_data in GameManager.buildings_data:
		if building_data["tileID"] == buildingID+10:
			str = "Update to " + building_data["name"] + "\n"
			str += "Cost: " + str(building_data["cost"]) + " golds" + "\n"
			str += "Prosperity: +" + str(building_data["prosperity"]) + "\n"
			if building_data["money"] != 0:
				str += "Earn Gold: +" + str(building_data["money"]) + " golds per day" + "\n"
	var updateLable = get_child(0)
	updateLable.text = str
	pass
	
	

func _on_pressed():
	#+6---index
	var index
	if buildingID < 10:
		index = buildingID + 6
	else:
		index = buildingID + 2
	var cost = GameManager.buildings_data[index].cost
	var prosperity = GameManager.buildings_data[index].prosperity
	if GameManager.gold >= cost:
		GameManager.gold -= cost
		GameManager.prosperity += prosperity
		#if buildingID == 建筑工地     speed+1
		tileMap.set_cell(tileMap.buildingLayer,updateCellPos,buildingID+10,Vector2i(0,0))
		GameManager.mapDict[updateCellPos] = buildingID+10
		pushComponents()
		levelUp()
	else :
		var error_pannel = get_node("/root/MainScene/ErrorPannel")
		error_pannel.popup_centered()
	self.hide()
	pass # Replace with function body.


func pushComponents():
	var _credential = {
			"gold": GameManager.gold,
			"prosperity": GameManager.prosperity,
			"construction_speed": GameManager.construction_speed,
			"id": GameManager.user_id,
	}
	HttpLayer._pushComponents(_credential);
	emit_signal("attributes_show")

func levelUp():
	var buildingType = buildingID
	if buildingID >= 10:
		buildingType -= 10
	var _credential = {
			"x": updateCellPos.x,
			"y": updateCellPos.y,
			"houseType": buildingType,
			"id": GameManager.user_id,
	}
	HttpLayer._levelUp(_credential);
	