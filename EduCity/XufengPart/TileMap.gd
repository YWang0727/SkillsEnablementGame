extends TileMap

signal store_components

var selectedTile: int = 98
var selectedLayer: int = 1
var buildingLayer: int = 2
var selectedBuildingType: int = -1  # 选择的图块索引

# Called when the node enters the scene tree for the first time.
func _ready():
	_drawMap()
	HttpLayer.connect("http_completed", http_completed)
	HttpLayer._readMap()

func _input(event: InputEvent) -> void:
	var cellPos
	var cost = GameManager.buildings_data[selectedBuildingType].cost
	var prosperity = GameManager.buildings_data[selectedBuildingType].prosperity
	var money = GameManager.buildings_data[selectedBuildingType].money
	
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
				if selectedBuildingType == 4:
					GameManager.construction_speed += 1
				clear_layer(selectedLayer)
				set_cell(buildingLayer,cellPos,selectedBuildingType,Vector2i(0,0))  # 在指定单元位置上放置选定的图块索引
				_updateMapDict(selectedBuildingType, cellPos)
				selectedBuildingType = -1
				emit_signal("store_components")
				var _credential = {
					"x": cellPos.x,
					"y": cellPos.y,
					"houseType": selectedBuildingType,
					"id": GameManager.user_id,
				}
				HttpLayer._buildHouse(_credential);
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _drawMap() -> void:
	for key in GameManager.mapDict.keys():
		var id = GameManager.mapDict[key]
		if id != selectedTile:
			set_cell(buildingLayer, key, id, Vector2i(0,0))

# If a new building overlaps with an existing house, return false
func _checkCellOverlap(selectedBuildingType, cellPos) -> bool:
	match selectedBuildingType:
		# a building occupying 1 cell
		GameManager.BuildingType.residential_building_1:
			if GameManager.mapDict.has(cellPos):
				return false
		# a building occupying 2 cells
		GameManager.BuildingType.supermarket_1, GameManager.BuildingType.hospital_1, GameManager.BuildingType.farm_1, GameManager.BuildingType.constrction_site_1:
			if GameManager.mapDict.has(cellPos) or GameManager.mapDict.has(cellPos+Vector2i(1, 0)):
				return false
		# a building occupying 4 cells
		GameManager.BuildingType.bank_1:
			if GameManager.mapDict.has(cellPos) or GameManager.mapDict.has(cellPos+Vector2i(1, 0)) or GameManager.mapDict.has(cellPos+Vector2i(0, 1)) or GameManager.mapDict.has(cellPos+Vector2i(1, 1)):
				return false
	return true
	
func _drawSelectedCells(selectedBuildingType, cellPos) -> void:
	match selectedBuildingType:
		# a building occupying 1 cell
		GameManager.BuildingType.residential_building_1:
			set_cell(selectedLayer,cellPos,selectedTile,Vector2i(0,0))
		# a building occupying 2 cells
		GameManager.BuildingType.supermarket_1, GameManager.BuildingType.hospital_1, GameManager.BuildingType.farm_1, GameManager.BuildingType.constrction_site_1:
			set_cell(selectedLayer,cellPos,selectedTile,Vector2i(0,0))
			set_cell(selectedLayer,cellPos+Vector2i(1, 0),98,Vector2i(0,0))
		# a building occupying 4 cells
		GameManager.BuildingType.bank_1:
			set_cell(selectedLayer,cellPos,selectedTile,Vector2i(0,0))
			set_cell(selectedLayer,cellPos+Vector2i(1, 0),98,Vector2i(0,0))
			set_cell(selectedLayer,cellPos+Vector2i(0, 1),98,Vector2i(0,0))
			set_cell(selectedLayer,cellPos+Vector2i(1, 1),98,Vector2i(0,0))

func _updateMapDict(selectedBuildingType, cellPos) -> void:
	match selectedBuildingType:
		# a building occupying 1 cell
		GameManager.BuildingType.residential_building_1:
			GameManager.mapDict[cellPos] = selectedBuildingType
		# a building occupying 2 cells
		GameManager.BuildingType.supermarket_1, GameManager.BuildingType.hospital_1, GameManager.BuildingType.farm_1, GameManager.BuildingType.constrction_site_1:
			GameManager.mapDict[cellPos] = selectedBuildingType
			GameManager.mapDict[cellPos+Vector2i(1, 0)] = selectedTile
		# a building occupying 4 cells
		GameManager.BuildingType.bank_1:
			GameManager.mapDict[cellPos] = selectedBuildingType
			GameManager.mapDict[cellPos+Vector2i(1, 0)] = selectedTile
			GameManager.mapDict[cellPos+Vector2i(0, 1)] = selectedTile
			GameManager.mapDict[cellPos+Vector2i(1, 1)] = selectedTile



func http_completed(res, response_code, headers, route):
	if route == "readMap":
		for i in range(0, res.num):
			var cellPos_temp
			cellPos_temp.x = res.x[i]
			cellPos_temp.y = res.y[i]
			GameManager.mapDict[cellPos_temp] = res.houseType

		
		
