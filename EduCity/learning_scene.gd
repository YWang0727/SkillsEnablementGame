extends Node2D

var backButton = Button.new()
var aiButton = Button.new()
var securityButton = Button.new()
var cloudButton = Button.new()
var dsButton = Button.new()
var automationButton = Button.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	backButton = get_node("BackButton")
	backButton.connect("pressed", _on_backButton_pressed)
	
	aiButton = get_node("AI/AIButton")
	aiButton.connect("pressed", _on_aiButton_pressed)
	
	securityButton = get_node("Security/SecurityButton")
	securityButton.connect("pressed", _on_securityButton_pressed)
	
	cloudButton = get_node("Cloud/CloudButton")
	cloudButton.connect("pressed", _on_cloudButton_pressed)
	
	dsButton = get_node("DS/DSButton")
	dsButton.connect("pressed", _on_dsButton_pressed)
	
	automationButton = get_node("Automation/AutomationButton")
	automationButton.connect("pressed", _on_automationButton_pressed)

func _on_backButton_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn")


func _on_aiButton_pressed():
	var popup = get_node("AI/PopupMenu_ai")
	popup.visible = true


func _on_securityButton_pressed():
	var popup = get_node("Security/PopupMenu_security")
	popup.visible = true
	
	
func _on_cloudButton_pressed():
	var popup = get_node("Cloud/PopupMenu_cloud")
	popup.visible = true
	
	
func _on_dsButton_pressed():
	var popup = get_node("DS/PopupMenu_ds")
	popup.visible = true
	
	
func _on_automationButton_pressed():
	var popup = get_node("Automation/PopupMenu_automation")
	popup.visible = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
