extends Node2D

@onready var tileMap : Node = get_node("/root/MainScene/TileMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mousePos = get_global_mouse_position() - Vector2(tileMap.position.x, tileMap.position.y)
		var cellPos = tileMap.local_to_map(mousePos)
		var position = tileMap.map_to_local(cellPos)
		if GameManager.mapDict.has(cellPos):
			self.position = position - Vector2(20,100)
			self.show()
		else:
			self.hide()
	pass
