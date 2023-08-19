extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#User operation will update the last active time	
func _input(event):
	GameManager.user_lastActiveTime = Time.get_unix_time_from_system()

