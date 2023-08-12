extends TileMap

signal store_components
signal attributes_show2

var inBuildingTile: int = 96
var selectedTile: int = 98
var selectedLayer: int = 1
var buildingLayer: int = 2
var selectedBuildingType: int = -1  # 选择的图块索引
var cellPosArray2D = [] # 储存每个房子的占地cell，防止overlap
@onready var fontResourse = preload("res://Font/Roboto/Roboto-Medium.ttf")

# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.connect("http_completed", http_completed)
	_drawMap()
	generateCellPosArray2D()
	var readyFlage = 1
	

func _unhandled_input(event) -> void:
	var cellPos
	var cost = GameManager.buildings_data[selectedBuildingType].cost
	var prosperity = GameManager.buildings_data[selectedBuildingType].prosperity
	var money = GameManager.buildings_data[selectedBuildingType].money
	
	# Show selected building when mouse hover if the building can be updated
	if event is InputEventMouseMotion and selectedBuildingType == -1:
		cellPos = local_to_map(get_global_mouse_position() - position)  # 将全局位置转换为TileMap单元位置
		clear_layer(selectedLayer)
		_drawSelectedUpdatedCells(cellPos)
			
	# After choosing a building type, show selected cells when mouse hover
	if event is InputEventMouseMotion and selectedBuildingType != -1:
		# Check if have enough gold to build a building
		if cost <= GameManager.gold:
			cellPos = local_to_map(get_global_mouse_position() - position)  # 将全局位置转换为TileMap单元位置
			clear_layer(selectedLayer)
			if _checkCellOverlap(selectedBuildingType,cellPos):
				_drawSelectedCells(selectedBuildingType,cellPos)
		else:
			var error_pannel = get_node("/root/MainScene/ErrorPannel")
			error_pannel.popup_centered()
			selectedBuildingType = -1
			
	# After pressing mouse on a cell, place a new building
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and selectedBuildingType != -1:
		if  selectedBuildingType == 0 or (selectedBuildingType > 0 and GameManager.statusList[selectedBuildingType - 1] == 2):
			cellPos = local_to_map(get_global_mouse_position() - position)  # 将鼠标位置转换为TileMap单元位置
			if _checkCellOverlap(selectedBuildingType,cellPos):
				GameManager.gold = GameManager.gold - cost
				#GameManager.prosperity += prosperity
				#if selectedBuildingType == 4 and GameManager.construction_speed < 6:
					#GameManager.construction_speed += 1
				emit_signal("store_components")
				_http_buildHouse(cellPos,selectedBuildingType)
				clear_layer(selectedLayer)
				_drawInBuildingCellsLabel(selectedBuildingType,cellPos)
				selectedBuildingType = -1


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for cellPos in GameManager.mapDict.keys():
		if GameManager.mapDict[cellPos]["finish_time"] != 0:
			var buildFinishTimestamp:int = GameManager.mapDict[cellPos]["finish_time"]
			var nowTimestamp:int = Time.get_unix_time_from_system()
			if buildFinishTimestamp >= nowTimestamp:
				_setLabelText(cellPos,buildFinishTimestamp - nowTimestamp)
			else:
				_eraseInBuildingCells(GameManager.mapDict[cellPos]["house_type"],cellPos)
				set_cell(buildingLayer,cellPos,GameManager.mapDict[cellPos]["house_type"],Vector2i(0,0))
				_freeLabel(cellPos)
				_http_ClearMapTime(cellPos)


#---------------------------------------------------------------------------
#------------------------------Draw Functions-------------------------------
#---------------------------------------------------------------------------
func _drawMap() -> void:
	for cellPos in GameManager.mapDict.keys():
		var id = GameManager.mapDict[cellPos]["house_type"]
		if GameManager.mapDict[cellPos]["finish_time"] == 0:
			set_cell(buildingLayer, cellPos, id, Vector2i(0,0))
		else:
			_drawInBuildingCellsLabel(id,cellPos)
			

func _drawInBuildingCellsLabel(selectedBuildingType, cellPos) -> void:
	var label = Label.new()
	label.name = "Label" + str(cellPos)
	label.position = map_to_local(cellPos)
	label.add_theme_font_override("font", fontResourse)
	label.add_theme_font_size_override("font_size", 18)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)
	var cellsCount = _getCellsCount(selectedBuildingType)
	match cellsCount:
		# a building occupying 1 cell
		1:
			set_cell(buildingLayer,cellPos,inBuildingTile,Vector2i(0,0))
			label.position = map_to_local(cellPos) - Vector2(64,40)
		# a building occupying 2 cells
		2:
			set_cell(buildingLayer,cellPos,inBuildingTile,Vector2i(0,0))
			set_cell(buildingLayer,cellPos+Vector2i(1, 0),inBuildingTile,Vector2i(0,0))
			label.position = map_to_local(cellPos) - Vector2(32,16)
		# a building occupying 4 cells
		4:
			set_cell(buildingLayer,cellPos,inBuildingTile,Vector2i(0,0))
			set_cell(buildingLayer,cellPos+Vector2i(1, 0),inBuildingTile,Vector2i(0,0))
			set_cell(buildingLayer,cellPos+Vector2i(0, 1),inBuildingTile,Vector2i(0,0))
			set_cell(buildingLayer,cellPos+Vector2i(1, 1),inBuildingTile,Vector2i(0,0))
			label.position = map_to_local(cellPos) - Vector2(64,-2)


func _eraseInBuildingCells(selectedBuildingType,cellPos) -> void:
	var cellsCount = _getCellsCount(selectedBuildingType)
	match cellsCount:
		# a building occupying 1 cell
		1:
			erase_cell(buildingLayer,cellPos)
		# a building occupying 2 cells
		2:
			erase_cell(buildingLayer,cellPos)
			erase_cell(buildingLayer,cellPos+Vector2i(1, 0))
		# a building occupying 4 cells
		4:
			erase_cell(buildingLayer,cellPos)
			erase_cell(buildingLayer,cellPos+Vector2i(1, 0))
			erase_cell(buildingLayer,cellPos+Vector2i(0, 1))
			erase_cell(buildingLayer,cellPos+Vector2i(1, 1))
	pass


func _drawSelectedCells(selectedBuildingType, cellPos) -> void:
	var cellsCount = _getCellsCount(selectedBuildingType)
	match cellsCount:
		# a building occupying 1 cell
		1:
			set_cell(selectedLayer,cellPos,selectedTile,Vector2i(0,0))
		# a building occupying 2 cells
		2:
			set_cell(selectedLayer,cellPos,selectedTile,Vector2i(0,0))
			set_cell(selectedLayer,cellPos+Vector2i(1, 0),98,Vector2i(0,0))
		# a building occupying 4 cells
		4:
			set_cell(selectedLayer,cellPos,selectedTile,Vector2i(0,0))
			set_cell(selectedLayer,cellPos+Vector2i(1, 0),98,Vector2i(0,0))
			set_cell(selectedLayer,cellPos+Vector2i(0, 1),98,Vector2i(0,0))
			set_cell(selectedLayer,cellPos+Vector2i(1, 1),98,Vector2i(0,0))

func _drawSelectedUpdatedCells(cellPos):
	var targetRow
	var found = false
	for row in cellPosArray2D:
		if found:
			break
		for x in row:
			if x == cellPos:
				targetRow = row
				found = true
				break
	if found:
		# Level3 buildings can't be updated any more
		if GameManager.mapDict[targetRow[0]]["house_type"] < 20:
			for x in targetRow:
				set_cell(selectedLayer,x,selectedTile,Vector2i(0,0))


#---------------------------------------------------------------------------
#----------------------------Support Functions------------------------------
#---------------------------------------------------------------------------
func generateCellPosArray2D():
	cellPosArray2D = []
	for cellPos in GameManager.mapDict:
		var value:int = GameManager.mapDict[cellPos]["house_type"]
		var cellsCount = _getCellsCount(value)
		match cellsCount:
			# a building occupying 1 cell
			1:
				cellPosArray2D.append([cellPos])
			# a building occupying 2 cells
			2:
				cellPosArray2D.append([cellPos, cellPos+Vector2i(1, 0)])
			# a building occupying 4 cells
			4:
				cellPosArray2D.append([cellPos, cellPos+Vector2i(1, 0), cellPos+Vector2i(0, 1), cellPos+Vector2i(1, 1)])

func addCellPosArray2D(cellPos,buildingID):
	var cellsCount = _getCellsCount(buildingID)
	match cellsCount:
		# a building occupying 1 cell
		1:
			cellPosArray2D.append([cellPos])
		# a building occupying 2 cells
		2:
			cellPosArray2D.append([cellPos, cellPos+Vector2i(1, 0)])
		# a building occupying 4 cells
		4:
			cellPosArray2D.append([cellPos, cellPos+Vector2i(1, 0), cellPos+Vector2i(0, 1), cellPos+Vector2i(1, 1)])

func _getCellsCount(id:int) -> int:
	match id:
		# a building occupying 1 cell
		GameManager.BuildingType.residential_building_1, \
		GameManager.BuildingType.residential_building_2, \
		GameManager.BuildingType.residential_building_3:
			return 1
		# a building occupying 2 cells
		GameManager.BuildingType.supermarket_1, \
		GameManager.BuildingType.supermarket_2, \
		GameManager.BuildingType.supermarket_3, \
		GameManager.BuildingType.hospital_1, \
		GameManager.BuildingType.hospital_2, \
		GameManager.BuildingType.hospital_3, \
		GameManager.BuildingType.farm_1, \
		GameManager.BuildingType.farm_2, \
		GameManager.BuildingType.farm_3,\
		GameManager.BuildingType.constrction_site_1,\
		GameManager.BuildingType.constrction_site_2,\
		GameManager.BuildingType.constrction_site_3:
			return 2
		# a building occupying 4 cells
		GameManager.BuildingType.bank_1, \
		GameManager.BuildingType.bank_2, \
		GameManager.BuildingType.bank_3:
			return 4
	return 0

func _ifContainsCellPos(cellPosArray2D, targetCellPos):
	for row in cellPosArray2D:
		for cellPos in row:
			if cellPos == targetCellPos:
				return true
	return false

# If a new building overlaps with an existing house, return false
func _checkCellOverlap(selectedBuildingType, cellPos) -> bool:
	var cellsCount = _getCellsCount(selectedBuildingType)
	match cellsCount:
		# a building occupying 1 cell
		1:
			if _ifContainsCellPos(cellPosArray2D,cellPos):
				return false
		# a building occupying 2 cells
		2:
			if _ifContainsCellPos(cellPosArray2D,cellPos) or\
			_ifContainsCellPos(cellPosArray2D,cellPos+Vector2i(1, 0)):
				return false
		# a building occupying 4 cells
		4:
			if _ifContainsCellPos(cellPosArray2D,cellPos) or\
			_ifContainsCellPos(cellPosArray2D,cellPos+Vector2i(1, 0)) or\
			_ifContainsCellPos(cellPosArray2D,cellPos+Vector2i(0, 1)) or\
			_ifContainsCellPos(cellPosArray2D,cellPos+Vector2i(1, 1)):
				return false
	return true

func _setLabelText(cellPos, timeDifference):
	var hours = timeDifference / 3600
	var minutes = (timeDifference % 3600) / 60
	var seconds = timeDifference % 60
	var label = get_node("Label" + str(cellPos))
	if label:
		label.text = "Time Remaining \n For Building: \n" + str(hours) + ":" + str(minutes) + ":" + str(seconds)

func _freeLabel(cellPos):
	var label = get_node("Label" + str(cellPos))
	if label:
		label.queue_free()

#---------------------------------------------------------------------------
#---------------------------------Signals-----------------------------------
#---------------------------------------------------------------------------
func _on_update_button_attributes_show():
	emit_signal("attributes_show2")


#---------------------------------------------------------------------------
#---------------------------------HTTPLAYER---------------------------------
#---------------------------------------------------------------------------
func http_completed(res, response_code, headers, route):
	#if token is checked and valid, return true
	if !AlertPopup.tokenCheck(res):
		return	

func _http_ClearMapTime(cellPos):
	var _credential = {
		"x": cellPos.x,
		"y": cellPos.y,
		"houseType": GameManager.mapDict[cellPos]["house_type"],
		"id": GameManager.user_id,
	}
	HttpLayer._clearMapTime(_credential)
	# update gameManager
	GameManager.mapDict[cellPos]["finish_time"] = 0
	_chang_attibution_after_build(GameManager.mapDict[cellPos]["house_type"])

func _chang_attibution_after_build(selectedBuildingType):
	var prosperity = GameManager.buildings_data[selectedBuildingType].prosperity
	GameManager.prosperity += prosperity
	if selectedBuildingType == 4 and GameManager.construction_speed < 6:
		GameManager.construction_speed += 1
	emit_signal("store_components")

func _http_buildHouse(cellPos,selectedBuildingType):
	# Caculate build hours according to the construction speed now
	var buildHours = 24 - (GameManager.construction_speed - 1) * 4
	var nowTimestamp:int = Time.get_unix_time_from_system()
	#var finishTime = nowTimestamp + buildHours * 3600
	var finishTime = nowTimestamp + buildHours #用于测试，现单位为秒
	var _credential = {
		"x": cellPos.x,
		"y": cellPos.y,
		"houseType": selectedBuildingType,
		"id": GameManager.user_id,
		"finishTime": finishTime
	}
	HttpLayer._buildHouse(_credential)
	# update gameManager
	GameManager.mapDict[cellPos] = {"house_type":selectedBuildingType, "finish_time":finishTime}
	addCellPosArray2D(cellPos,selectedBuildingType)



	
