extends Control

var isExpanded = true

@onready var tileMap : Node = get_node("/root/MainScene/TileMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _onToggleButtonPressed():
	if isExpanded:
		set_position(Vector2(1920, 0))
		isExpanded = false
	else:
		set_position(Vector2(1620, 0))
		isExpanded = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_res_building_button_pressed():
	tileMap.selectedBuildingType = GameManager.BuildingType.residential_building_1

func _on_supermarket_button_pressed():
	if GameManager.statusList[0] == 2:
		tileMap.selectedBuildingType = GameManager.BuildingType.supermarket_1

func _on_bank_button_pressed():
	if GameManager.statusList[1] == 2:
		tileMap.selectedBuildingType = GameManager.BuildingType.bank_1

func _on_farm_button_pressed():
	if GameManager.statusList[2] == 2:
		tileMap.selectedBuildingType = GameManager.BuildingType.farm_1

func _on_construction_site_button_pressed():
	if GameManager.statusList[3] == 2:
		tileMap.selectedBuildingType = GameManager.BuildingType.constrction_site_1

func _on_hospital_button_pressed():
	if GameManager.statusList[4] == 2:
		tileMap.selectedBuildingType = GameManager.BuildingType.hospital_1

func _on_button_pressed():
	get_tree().change_scene_to_file("res://LearningPage/learning_scene.tscn")
	pass # Replace with function body.
