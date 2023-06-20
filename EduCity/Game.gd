extends Node2D

var loginScene 
var mainScene 

# Called when the node enters the scene tree for the first time.
func _ready():
	loginScene = get_node("loginScene")
	loginScene.visible = true
	mainScene = get_node("MainScene")
	mainScene.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
