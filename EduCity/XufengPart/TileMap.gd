extends TileMap

signal store_components
signal attributes_show2

var selectedTile: int = 98
var selectedLayer: int = 1
var buildingLayer: int = 2
var selectedBuildingType: int = -1  # 选择的图块索引
var cellPosArray2D = [] # 储存每个房子的占地cell，防止overlap

# Called when the node enters the scene tree for the first time.
func _ready():
	_drawMap()
	generateCellPosArray2D()
	#HttpLayer.connect("http_completed", http_completed)
	#HttpLayer._readMap()
	

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
				GameManager.prosperity += prosperity
				if selectedBuildingType == 4 and GameManager.construction_speed < 6:
					GameManager.construction_speed += 1
				clear_layer(selectedLayer)
				set_cell(buildingLayer,cellPos,selectedBuildingType,Vector2i(0,0))  # 在指定单元位置上放置选定的图块索引
				_updateMapDict(selectedBuildingType, cellPos)
				emit_signal("store_components")
				
				var _credential = {
					"x": cellPos.x,
					"y": cellPos.y,
					"houseType": selectedBuildingType,
					"id": GameManager.user_id,
				}
				HttpLayer._buildHouse(_credential);
				selectedBuildingType = -1
				
				
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _drawMap() -> void:
	for key in GameManager.mapDict.keys():
		var id = GameManager.mapDict[key]
		if id != GameManager.BuildingType.blank:
			set_cell(buildingLayer, key, id, Vector2i(0,0))

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


func _updateMapDict(selectedBuildingType, cellPos) -> void:
	var cellsCount = _getCellsCount(selectedBuildingType)
	GameManager.mapDict[cellPos] = selectedBuildingType
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



func http_completed(res, response_code, headers, route):
	if route == "readMap":
		for i in range(0, res.num):
			var cellPos_temp
			cellPos_temp = local_to_map(position)
			cellPos_temp.x = res.x[i]
			cellPos_temp.y = res.y[i]
			GameManager.mapDict[cellPos_temp] = res.houseType[i]
			set_cell(buildingLayer,cellPos_temp,res.houseType[i],Vector2i(0,0))
			


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


func _on_update_button_attributes_show():
	emit_signal("attributes_show2")
	pass # Replace with function body.
	
	
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
		if GameManager.mapDict[targetRow[0]] < 20:
			for x in targetRow:
				set_cell(selectedLayer,x,selectedTile,Vector2i(0,0))


func generateCellPosArray2D():
	for cellPos in GameManager.mapDict:
		var value:int = GameManager.mapDict[cellPos]
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
			
