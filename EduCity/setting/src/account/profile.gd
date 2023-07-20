extends Control

# preload the HttpLayer_Account Node
var HttpLayer_Account = preload("res://setting/src/account/HttpLayer_Account.gd")
var account_API
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
var constructionSite: Label
var avatar: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	initiate_variables()
	connect_signals()
	
	# it turns out a signal can only be connected to one function...
	HttpLayer.http_completed.connect(http_completed)
	
	# render profile
	# fetch user basic infomation data from server
	account_API.fetch_user_info(GameManager.user_id)
	# fetch user's property infomation from server
	account_API.fetch_user_property_info(GameManager.user_id)


func initiate_variables():
	account_API = HttpLayer_Account.new()

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
	get_tree().change_scene_to_file(main_scene)

# process response got from server
func http_completed(res, response_code, headers, route):
	if (response_code == 200):
		print(res.msg)
		# check if code in resultVO is 0000(SUCCESS)
		if (res.code != 0):
			print(res.data)
			return
		
		if (route == "getUserInfo"):
			display_user_info(res.data)
		elif (route == "getPropertyInfo"):
			display_user_property_info(res.data)
			
	else:
		if (route == "getUserInfo"):
			print("Fail to get user's information")
		elif (route == "getPropertyInfo"):
			print("Fail to get user's property information")

# diaplay user basic infomation in labels
func display_user_info(data):
	username.text = data.name
	prosperity.text = str(data.prosperity)
	gold.text = str(data.gold)
	
	# display byte data encoded as String of avatar
	var avatarStr = data.avatarStr
	if (avatarStr != null && avatarStr != ""):
		display_user_avatar(avatarStr)

# decode avatar data stored in string and display it
func display_user_avatar(avatarStr: String):
	# decode string to byte
	var avatarData = Marshalls.base64_to_raw(avatarStr)
	
	var image = Image.new()
	var isJPG = check_image_format(avatarData)
	if (isJPG):
		image.load_jpg_from_buffer(avatarData)
	else :
		image.load_png_from_buffer(avatarData)
		
	var image_texture = ImageTexture.create_from_image(image)
	avatar.texture = image_texture

# return true if image is in jpg format, false if in png
func check_image_format(imageData: PackedByteArray) -> bool:
	var signature = imageData.slice(0, 4);
	if (signature == PackedByteArray([0xFF, 0xD8, 0xFF, 0xE0])):
		return true
	return false

# diaplay user property infomation in label
func display_user_property_info(data):
	residentialBuilding.text = str(data.residentialBuildingAmount)
	bank.text = str(data.bankAmount)
	supermarket.text = str(data.supermarketAmount)
	hospital.text = str(data.hospitalAmount)
	farm.text = str(data.farmAmount)
	constructionSite.text = str(data.constructionSiteAmount)
