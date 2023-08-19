extends Node2D
var guideScene = preload("res://loginPage/GuideScene.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	#HttpLayer.connect("http_completed", http_completed)
	if GameManager.user_isFirst == 1:
		var guide = guideScene.instantiate()
		if (!get_parent().has_node("guide")):
			get_parent().add_child(guide)
			guide.visible = true
		HttpLayer._setUserNotFirst(
			{
				"id": GameManager.user_id,
				"isFist": GameManager.user_isFirst
			}
		)
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#User operation will update the last active time	
func _input(event):
	GameManager.user_lastActiveTime = Time.get_unix_time_from_system()

