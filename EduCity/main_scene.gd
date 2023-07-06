extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_components_leader_board():
	var s = preload("res://Leaderboard/leaderboard.tscn").instantiate()
	add_child(s)


func _on_components_study():
	var s = preload("res://learning_scene.tscn").instantiate()
	add_child(s)
