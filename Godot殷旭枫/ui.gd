extends Node2D

@onready var tileMap : Node = get_node("/root/Node2D/TileMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_house_button_pressed():
	tileMap.selectedTileIndex = 1
	pass # Replace with function body.


func _on_shop_button_pressed():
	tileMap.selectedTileIndex = 2
	pass # Replace with function body.


func _on_construction_button_pressed():
	tileMap.selectedTileIndex = 3
	pass # Replace with function body.


func _on_barber_button_pressed():
	tileMap.selectedTileIndex = 4
	pass # Replace with function body.
