extends Control

@export var scene:String = "res://LearningPage/reading_scene.tscn"
@onready var _animated_sprite = $AnimatedSprite2D

var scene_load_status = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(scene)
	_animated_sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# get loading status
	scene_load_status = ResourceLoader.load_threaded_get_status(scene)
	print(_animated_sprite.frame)
	print("status" + str(scene_load_status))
	# if loaded, change scene
	if scene_load_status == 3:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene))
		queue_free()
		

	
