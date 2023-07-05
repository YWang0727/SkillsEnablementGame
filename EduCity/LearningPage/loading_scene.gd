extends Control

@export var scene:String = "res://LearningPage/reading_scene.tscn"
@onready var progressBar:ProgressBar = $ProgressBar

var progress = []
var scene_load_status = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# get loading status
	scene_load_status = ResourceLoader.load_threaded_get_status(scene, progress)
	# set progressBar's value
	progressBar.value = progress[0] + 100
	# if loaded, change scene
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		_on_loaded()
		
		
func _on_loaded():
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene))
		queue_free()
	
