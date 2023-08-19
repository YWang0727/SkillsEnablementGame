extends Control

var picture;
var currentImageIndex : int = 0
var imagePaths : Array = ["res://loginPage/img/guidePictures/1.png", "res://loginPage/img/guidePictures/2.png", 
"res://loginPage/img/guidePictures/3.png","res://loginPage/img/guidePictures/4.png","res://loginPage/img/guidePictures/5.png",
"res://loginPage/img/guidePictures/6.png","res://loginPage/img/guidePictures/7.png","res://loginPage/img/guidePictures/8.png"]
var buttonSound: AudioStreamPlayer2D
var cancelSound: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	picture = get_node("Picture")
	buttonSound = get_node("ButtonSound")
	cancelSound = get_node("CancelSound")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_skip_pressed():
	cancelSound.play()
	self.hide()
	
func _on_close_pressed():
	cancelSound.play()
	self.hide()


func _on_next_pressed():
	buttonSound.play()
	currentImageIndex += 1
	if currentImageIndex >= imagePaths.size():
		currentImageIndex = imagePaths.size() - 1
	
	load_image()


func _on_prev_pressed():
	buttonSound.play()
	currentImageIndex -= 1
	if currentImageIndex < 0:
		currentImageIndex = 0
	
	load_image()

func load_image():
	var imageTexture = load(imagePaths[currentImageIndex]) as Texture
	picture.texture = imageTexture
	

