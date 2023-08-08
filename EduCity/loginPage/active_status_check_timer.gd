extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	#print("launch active check timer")
	#self.wait_time = 5
	self.connect("timeout", _on_Timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func startTimer():
	print("timer start!!!!")
	var cur_time:int = Time.get_unix_time_from_system() 
	print(cur_time)
	self.start(60.0)
	
func _on_Timer_timeout():
	if get_tree().current_scene.name == "LogSignScene":
		return
	if IsUserActive():
		print("用户活跃！")
		return
	else:
		print("用户不活跃，超时！")
		AlertPopup.setPosition(0,0,'center')
		AlertPopup.show_error_message("      Logged out due to inactivity. Please login.")
		get_tree().change_scene_to_file("res://loginPage/login.tscn")
		self.stop()
		
func IsUserActive()-> bool:
	var cur_time:int = Time.get_unix_time_from_system() 
	var cur_sec = cur_time
	var last_sec:int = GameManager.user_lastActiveTime
	
	var time_diff:int = (cur_sec - last_sec) + 2
	print(time_diff)
	
	if time_diff >= 3*60.0:
		return false
	else:
		return true
