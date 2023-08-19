extends Button
var guideScene = preload("res://loginPage/GuideScene.tscn")



func _on_pressed():
	$"../ButtonSound".play()
	var guide = guideScene.instantiate()
	if (!get_parent().has_node("guide")):
		get_parent().add_child(guide)
	guide.visible = true
