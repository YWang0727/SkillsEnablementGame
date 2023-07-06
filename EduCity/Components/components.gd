extends Node

signal leader_board
signal study
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_prosperity_pressed():
	emit_signal("leader_board")
	pass # Replace with function body.


func _on_gold_pressed():
	emit_signal("study")
	pass # Replace with function body.
