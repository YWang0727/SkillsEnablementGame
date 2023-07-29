extends Control

var account_setting_scene: String = "res://setting/src/account/account_setting.tscn"
var main_scene: String = ("res://main_scene.tscn")

# global variables
var accountSettingButton: Button
var backButton: Button
var username: Label
var email: Label
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
	display_user_info(GameManager.user_data)
	display_user_property_info(GameManager.property_data)
	
	HttpLayer.http_completed.connect(http_completed)
	
	# fetch user's property information from server
	HttpLayer.fetch_user_property_info(GameManager.user_id)

func initiate_variables():
	#buttons
	accountSettingButton = get_node("MarginContainer/Profile/BasicInfo/AccountSetting")
	backButton = get_node("BackButton")
	
	# they are used to show data fetched from server
	avatar = get_node("MarginContainer/Profile/Avatar")
	username = get_node("MarginContainer/Profile/BasicInfo/Username/Data")
	email = get_node("MarginContainer/Profile/BasicInfo/Email/Data")
	residentialBuilding = get_node("MarginContainer/Profile/PropertyInfo/ResidentialBuilding/Data")
	bank = get_node("MarginContainer/Profile/PropertyInfo/Bank/Data")
	supermarket = get_node("MarginContainer/Profile/PropertyInfo/Supermarket/Data")
	hospital = get_node("MarginContainer/Profile/PropertyInfo/Hospital/Data")
	farm = get_node("MarginContainer/Profile/PropertyInfo/Farm/Data")
	constructionSite = get_node("MarginContainer/Profile/PropertyInfo/ConstructionSite/Data")


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
	#if token is checked and valid, return true
	if !AlertPopup.tokenCheck(res):
		return	
	if (response_code == 200):
		print(res.msg)
		# check if code in resultVO is 0000(SUCCESS)
		if (res.code != 0):
			print(res.data)
			return
		
		update_user_property(res.data)
		display_user_property_info(GameManager.property_data)
			
	else:
		print("Fail to get user's property information")

# diaplay user basic infomation in labels
func display_user_info(user_data):
	username.text = user_data.name
	email.text = user_data.email
	
	# display byte data encoded as String of avatar
	var avatarStr = user_data.avatarStr
	if (avatarStr != null && avatarStr != ""):
		display_user_avatar(Marshalls.base64_to_raw(avatarStr))

# decode avatar data stored in string and display it
func display_user_avatar(avatarData: PackedByteArray):
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

func update_user_property(data):
	GameManager.property_data.residentialBuilding = str(data.residentialBuildingAmount)
	GameManager.property_data.bank = str(data.bankAmount)
	GameManager.property_data.supermarket = str(data.supermarketAmount)
	GameManager.property_data.hospital = str(data.hospitalAmount)
	GameManager.property_data.farm = str(data.farmAmount)
	GameManager.property_data.constructionSite = str(data.constructionSiteAmount)

# diaplay user property infomation in label
func display_user_property_info(property_data):
	residentialBuilding.text = property_data.residentialBuilding
	bank.text = property_data.bank
	supermarket.text = property_data.supermarket
	hospital.text = property_data.hospital
	farm.text = property_data.farm
	constructionSite.text = property_data.constructionSite
