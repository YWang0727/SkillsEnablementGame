extends TileMap

var selectedTileIndex: int = -1  # 选择的图块索引

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mousePos = get_global_mouse_position()  # 获取鼠标点击的全局位置
		var cellPos = local_to_map(mousePos)  # 将全局位置转换为TileMap单元位置
		set_cell(1,cellPos,selectedTileIndex,Vector2i(0,0))  # 在指定单元位置上放置选定的图块索引
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
