extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# fetch user basic infomation from server
func fetch_user_info(userId):
	HttpLayer._apiCore("setting/getUserInfo/" + str(userId), null, true, "GET", "getUserInfo")

func fetch_user_property_info(userId):
	HttpLayer._apiCore("setting/getPropertyInfo/" + str(userId), null, true, "GET", "getPropertyInfo")

# send editing password request to server
func edit_user_password(_credentials):
	HttpLayer._apiCore("setting/editPassword", _credentials, true, "PUT", "editPassword")


