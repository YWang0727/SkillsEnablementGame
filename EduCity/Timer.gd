extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.autostart = true
	self.wait_time = 300
	self.connect("timeout", _on_Timer_timeout)


func _on_Timer_timeout():
	if get_tree().current_scene.name == "MainScene":
		# auto save when time out
		print("timeout, go autosave")
		Saving.save_auto()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
