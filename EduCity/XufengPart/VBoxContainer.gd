extends VBoxContainer

# 这里有点蠢，没想好怎么改
@onready var res_building_message_node := get_node("ResBuildingButton/Message")
@onready var res_building_lable := res_building_message_node.get_node("Lable")
@onready var supermarket_message_node := get_node("SupermarketButton/Message")
@onready var supermarket_lable := supermarket_message_node.get_node("Lable")
@onready var bank_message_node := get_node("BankButton/Message")
@onready var bank_lable := bank_message_node.get_node("Lable")
@onready var farm_message_node := get_node("FarmButton/Message")
@onready var farm_lable := farm_message_node.get_node("Lable")
@onready var constrction_site_message_node := get_node("ConstructionSiteButton/Message")
@onready var constrction_site_lable := constrction_site_message_node.get_node("Lable")
@onready var hospital_message_node := get_node("HospitalButton/Message")
@onready var hospital_lable := hospital_message_node.get_node("Lable")

# Called when the node enters the scene tree for the first time.
func _ready():
	# 随着房屋升级这里的id参数也要变，但没想好怎么改
	res_building_lable.text = _load_message(0)
	supermarket_lable.text = _load_message(1)
	bank_lable.text = _load_message(2)
	farm_lable.text = _load_message(3)
	constrction_site_lable.text = _load_message(4)
	hospital_lable.text = _load_message(5)
	# 隐藏所有的message节点
	var buttons = get_children()  # 获取所有子节点
	for button in buttons:
		if button is Button:  # 检查节点是否为Button类型
			var control = button.get_node("Message")  # 替换 "Control" 为 Control 节点的路径
			if control:
				control.hide()  # 隐藏 Control 节点


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _load_message(id: int) -> String:
	var str: String
	str = "Name: " + GameManager.buildings_data[id]["name"] + "\n"
	str += "Cost: " + str(GameManager.buildings_data[id]["cost"]) + " golds" + "\n"
	str += "Prosperity: +" + str(GameManager.buildings_data[id]["prosperity"]) + "\n"
	str += "Earn Gold: +" + str(GameManager.buildings_data[id]["money"]) + " golds per day" + "\n"
	return str

func _on_res_building_button_mouse_entered():
	res_building_message_node.show()

func _on_res_building_button_mouse_exited():
	res_building_message_node.hide()

func _on_supermarket_button_mouse_entered():
	supermarket_message_node.show()

func _on_supermarket_button_mouse_exited():
	supermarket_message_node.hide()

func _on_bank_button_mouse_entered():
	bank_message_node.show()

func _on_bank_button_mouse_exited():
	bank_message_node.hide()

func _on_farm_button_mouse_entered():
	farm_message_node.show()

func _on_farm_button_mouse_exited():
	farm_message_node.hide()

func _on_construction_site_button_mouse_entered():
	constrction_site_message_node.show()

func _on_construction_site_button_mouse_exited():
	constrction_site_message_node.hide()

func _on_hospital_button_mouse_entered():
	hospital_message_node.show()

func _on_hospital_button_mouse_exited():
	hospital_message_node.hide()
