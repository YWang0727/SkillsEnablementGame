extends Node2D

@onready var tileMap : Node = get_node("/root/Node2D/TileMap")
enum BuildingType { residential_building_1, supermarket_1, bank_1, farm_1, constrction_site_1, hospital_1}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_res_building_button_pressed():
	tileMap.selectedBuildingType = BuildingType.residential_building_1

func _on_supermarket_button_pressed():
	tileMap.selectedBuildingType = BuildingType.supermarket_1

func _on_bank_button_pressed():
	tileMap.selectedBuildingType = BuildingType.bank_1

func _on_farm_button_pressed():
	tileMap.selectedBuildingType = BuildingType.farm_1

func _on_construction_site_button_pressed():
	tileMap.selectedBuildingType = BuildingType.constrction_site_1

func _on_hospital_button_pressed():
	tileMap.selectedBuildingType = BuildingType.hospital_1
