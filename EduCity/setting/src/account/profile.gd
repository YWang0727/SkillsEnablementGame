extends Control

# preload the HttpLayer_Account Node
var HttpLayer_Account = preload("res://setting/src/account/HttpLayer_Account.gd")
var account_setting_scene: String = "res://setting/src/account/account_setting.tscn"
var main_scene: String = ("res://main_scene.tscn")

# global variables
var accountSettingButton: Button
var backButton: Button
var username: Label
var prosperity: Label
var gold: Label
var residentialBuilding: Label
var bank: Label
var supermarket: Label
var hospital: Label
var farm: Label
var policeStation: Label
var avatar: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.user_id = 1
	initiate_variables()
	connect_signals()
	
	fetch_user_info()
	#fetch_user_property_info()


func initiate_variables():	
	#buttons
	accountSettingButton = get_node("MarginContainer/Profile/BasicInfo/AccountSetting")
	backButton = get_node("BackButton")
	
	# labels: which are used to show data fetched from server
	username = get_node("MarginContainer/Profile/BasicInfo/Username/Data")
	prosperity = get_node("MarginContainer/Profile/BasicInfo/Prosperity/Data")
	gold = get_node("MarginContainer/Profile/BasicInfo/Gold/Data")
	residentialBuilding = get_node("MarginContainer/Profile/PropertyInfo/ResidentialBuilding/Data")
	bank = get_node("MarginContainer/Profile/PropertyInfo/Bank/Data")
	supermarket = get_node("MarginContainer/Profile/PropertyInfo/Supermarket/Data")
	hospital = get_node("MarginContainer/Profile/PropertyInfo/Hospital/Data")
	farm = get_node("MarginContainer/Profile/PropertyInfo/Farm/Data")
	policeStation = get_node("MarginContainer/Profile/PropertyInfo/PoliceStation/Data")

	avatar = get_node("MarginContainer/Profile/Avatar")

func connect_signals():
	accountSettingButton.pressed.connect(_on_account_setting_pressed)
	backButton.pressed.connect(_on_back_button_pressed)

# jump to account setting interface
func _on_account_setting_pressed():
	get_tree().change_scene_to_file(account_setting_scene)

func _on_back_button_pressed():
	get_tree().change_scene_to_file(main_scene)







# fetch user basic infomation data from server
func fetch_user_info():
	var account_API = HttpLayer_Account.new()
	add_child(account_API)
	
	HttpLayer.http_completed.connect(display_user_info)
	account_API.fetch_user_info(GameManager.user_id)


# diaplay user basic infomation in label
func display_user_info(res, response_code, headers, route):
	username.text = res.name
	prosperity.text = str(res.prosperity)
	gold.text = str(res.gold)
	
	# display byte data of avatar
	var avatarStr = res.avatarStr
	if (avatarStr != null && avatarStr != ""):
		display_user_avatar(avatarStr)

# decode avatar data stored in string and display it
func display_user_avatar(avatarStr: String):
	var avatarData = Marshalls.base64_to_raw(avatarStr)
	var image = Image.new()
	image.load_jpg_from_buffer(avatarData)
	var image_texture = ImageTexture.create_from_image(image)
	avatar.texture = image_texture


# fetch user's property infomation from server
func fetch_user_property_info():
	var account_API2 = HttpLayer_Account.new()
	add_child(account_API2)
	
	HttpLayer.http_completed.connect(display_user_property_info)
	account_API2.fetch_user_property_info(GameManager.user_id)

# diaplay user property infomation in label
func display_user_property_info(res, response_code, headers, route):
	residentialBuilding.text = str(res.residentialBuildingAmount)
	bank.text = str(res.bankAmount)
	supermarket.text = str(res.supermarketAmount)
	hospital.text = str(res.hospitalAmount)
	farm.text = str(res.farmAmount)
	policeStation.text = str(res.policeStationAmount)
