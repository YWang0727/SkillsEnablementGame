extends TileMap

var selectedTile: int = 98
var selectedLayer: int = 1
var buildingLayer: int = 2
var selectedBuildingType: int = -1  # 选择的图块索引
var mapDict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	var cellPos
	# After choosing a building type, show selected cells when mouse hover
	if event is InputEventMouseMotion and selectedBuildingType != -1:
		cellPos = local_to_map(get_global_mouse_position())  # 将全局位置转换为TileMap单元位置
		clear_layer(selectedLayer)
		if _checkCellOverlap(selectedBuildingType,cellPos):
			_drawSelectedCells(selectedBuildingType,cellPos)
	# After pressing mouse on a cell, place a new building
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and selectedBuildingType != -1:
		cellPos = local_to_map(get_global_mouse_position())  # 将鼠标位置转换为TileMap单元位置
		if _checkCellOverlap(selectedBuildingType,cellPos):
			
			# 读取所属building的属性，验证是否有钱可以建造，建造后属性加成
			print(GameManager.buildings_data[selectedBuildingType])
			
			clear_layer(selectedLayer)
			set_cell(buildingLayer,cellPos,selectedBuildingType,Vector2i(0,0))  # 在指定单元位置上放置选定的图块索引
			_updateMapDict(selectedBuildingType, cellPos)
			selectedBuildingType = -1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# If a new building overlaps with an existing house, return false
func _checkCellOverlap(selectedBuildingType, cellPos) -> bool:
	match selectedBuildingType:
		# a building occupying 1 cell
		GameManager.BuildingType.residential_building_1:
			if mapDict.has(cellPos):
				return false
		# a building occupying 2 cells
		GameManager.BuildingType.supermarket_1, GameManager.BuildingType.hospital_1, GameManager.BuildingType.farm_1, GameManager.BuildingType.constrction_site_1:
			if mapDict.has(cellPos) or mapDict.has(cellPos+Vector2i(1, 0)):
				return false
		# a building occupying 4 cells
		GameManager.BuildingType.bank_1:
			if mapDict.has(cellPos) or mapDict.has(cellPos+Vector2i(1, 0)) or mapDict.has(cellPos+Vector2i(0, 1)) or mapDict.has(cellPos+Vector2i(1, 1)):
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
			mapDict[cellPos] = selectedBuildingType
		# a building occupying 2 cells
		GameManager.BuildingType.supermarket_1, GameManager.BuildingType.hospital_1, GameManager.BuildingType.farm_1, GameManager.BuildingType.constrction_site_1:
			mapDict[cellPos] = selectedBuildingType
			mapDict[cellPos+Vector2i(1, 0)] = selectedTile
		# a building occupying 4 cells
		GameManager.BuildingType.bank_1:
			mapDict[cellPos] = selectedBuildingType
			mapDict[cellPos+Vector2i(1, 0)] = selectedTile
			mapDict[cellPos+Vector2i(0, 1)] = selectedTile
			mapDict[cellPos+Vector2i(1, 1)] = selectedTile
