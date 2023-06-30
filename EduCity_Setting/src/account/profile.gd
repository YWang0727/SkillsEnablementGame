extends Control

# preload the HttpLayer_Account Node
var HttpLayer_Account = preload("res://src/account/HttpLayer_Account.gd")
var account_setting_scene:String = "res://src/account/account_setting.tscn"
var world_scene: String = ("res://src/sim_world/world.tscn")

# instance of HttpLayer_Account Node
var account_API

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
var constructionSite: Label
var avatar: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	initiate_variables()
	connect_signals()


func initiate_variables():
	account_API = HttpLayer_Account.new()
	add_child(account_API)
	
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
	constructionSite = get_node("MarginContainer/Profile/PropertyInfo/ConstructionSite/Data")

	avatar = get_node("MarginContainer/Profile/Avatar")

func connect_signals():
	accountSettingButton.pressed.connect(_on_account_setting_pressed)
	backButton.pressed.connect(_on_back_button_pressed)

# jump to account setting interface
func _on_account_setting_pressed():
	get_tree().change_scene_to_file(account_setting_scene)

func _on_back_button_pressed():
	get_tree().change_scene_to_file(world_scene)


# fetch user basic infomation data from server
func fetch_user_info():
	# http bind
	HttpLayer.http_completed.connect(display_user_info)
	account_API.fetch_user_info()

# fetch user's property infomation from server
func fetch_user_property_info():
	HttpLayer.http_completed.connect(display_user_property_info)
	account_API.fetch_user_property_info()

# diaplay user basic infomation in label
func display_user_info(res, response_code, headers, route):
	username.text = res.data.username
	prosperity.text = res.data.prosperity
	gold.text = res.data.gold

# diaplay user property infomation in label
func display_user_property_info(res, response_code, headers, route):
	residentialBuilding.text = res.data.residentialBuilding
	bank.text = res.data.bank
	supermarket.text = res.data.supermarket
	hospital.text = res.data.hospital
	farm.text = res.data.farm
	constructionSite.text = res.data.constructionSite


# TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
func fetch_user_avatar():
	account_API.fetch_user_avatar()
	
func display_user_avatar():
	#avatar.text = 
	pass
