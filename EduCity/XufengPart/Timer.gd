extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("timeout", _on_Timer_timeout)


func _on_Timer_timeout():
	# auto save when time out
	print("timeout, go autosave")
	Saving.save()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
