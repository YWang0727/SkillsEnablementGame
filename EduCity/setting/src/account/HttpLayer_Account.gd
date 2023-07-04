extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# fetch user basic infomation from server
func fetch_user_info():
	HttpLayer._apiCore("user/auth/getUserInfo", null, true, "GET", "getUserInfo", null)

func fetch_user_property_info():
	HttpLayer._apiCore("user/auth/getPropertyInfo", null, true, "GET", "getPropertyInfo", null)

# send editing profile request to server
func edit_user_profile(editedInfo):
	HttpLayer._apiCore("user/auth/editUserInfo", editedInfo, true, "PUT", "editUserInfo", null)

# send editing password request to server
func edit_user_password(editedPassword):
	HttpLayer._apiCore("user/auth/editPassword", editedPassword, true, "PUT", "editPassword", null)

# TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
# get user's avatar picture file from server
func fetch_user_avatar():
	pass

# send user's new avatar picture file to server
func save_user_avatar():
	pass

