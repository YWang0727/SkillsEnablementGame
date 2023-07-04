extends TileMap

var selectedTile: int = 98
var selectedLayer: int = 1
var buildingLayer: int = 2
var selectedBuildingType: int = -1  # 选择的图块索引
#这个enum待添加到gameMangager
enum BuildingType { residential_building_1, supermarket_1, bank_1, farm_1, constrction_site_1, hospital_1}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	var cellPos
	
	# 按下按钮后，鼠标hover时在地图上显示被选中的图块
	if event is InputEventMouseMotion and selectedBuildingType != -1:
		cellPos = local_to_map(get_global_mouse_position())  # 将全局位置转换为TileMap单元位置
		clear_layer(selectedLayer)
		match selectedBuildingType:
			# 占地1个cell的房子
			BuildingType.residential_building_1:
				set_cell(selectedLayer,cellPos,selectedTile,Vector2i(0,0))
			# 占地2个cell的房子
			BuildingType.supermarket_1, BuildingType.hospital_1, BuildingType.farm_1, BuildingType.constrction_site_1:
				set_cell(selectedLayer,cellPos,selectedTile,Vector2i(0,0))
				set_cell(selectedLayer,cellPos+Vector2i(1, 0),98,Vector2i(0,0))
			# 占地4个cell的房子
			BuildingType.bank_1:
				set_cell(selectedLayer,cellPos,selectedTile,Vector2i(0,0))
				set_cell(selectedLayer,cellPos+Vector2i(1, 0),98,Vector2i(0,0))
				set_cell(selectedLayer,cellPos+Vector2i(0, 1),98,Vector2i(0,0))
				set_cell(selectedLayer,cellPos+Vector2i(1, 1),98,Vector2i(0,0))
	
	# 鼠标press时建造房子
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and selectedBuildingType != -1:
		cellPos = local_to_map(get_global_mouse_position())  # 将鼠标位置转换为TileMap单元位置
		clear_layer(selectedLayer)
		set_cell(buildingLayer,cellPos,selectedBuildingType,Vector2i(0,0))  # 在指定单元位置上放置选定的图块索引
		selectedBuildingType = -1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
