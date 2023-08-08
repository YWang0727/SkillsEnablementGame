extends Button

var countdown_sec = 60
var timer
var activeButton

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _ready():
	timer = get_node("Timer")
	timer.connect("timeout", _on_timer_timeout)

func _on_pressed():
	
	self.disabled = true
	start_countdown()
	
func start_countdown():
	timer.start(1.0)
	countdown_sec = 60
	update_button_text()
	

func _on_timer_timeout():
	countdown_sec -= 1
	update_button_text()

	if countdown_sec <= 0:
		timer.stop()
		self.disabled = false

func update_button_text():
	if countdown_sec > 0:
		self.text = "Get new after " + str(countdown_sec) + " sec"
	else:
		self.text = "Get Active Code"



