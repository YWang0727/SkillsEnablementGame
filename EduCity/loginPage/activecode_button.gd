extends Button

var countdown_sec = 60
var timer
var activeButton

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _ready():
	# 创建一个定时器实例
	timer = get_node("Timer")
	# 将定时器的 timeout 信号连接到 _on_timer_timeout 方法
	timer.connect("timeout", _on_timer_timeout)

func _on_pressed():
	
	self.disabled = true
	start_countdown()
	
func start_countdown():
	
	# 启动定时器，每秒更新按钮上的文本
	timer.start(1.0)
	countdown_sec = 60
	update_button_text()
	

func _on_timer_timeout():
	# 定时器时间到，每秒更新按钮上的文本
	countdown_sec -= 1
	update_button_text()

	# 如果倒计时完成，停止定时器并启用按钮
	if countdown_sec <= 0:
		timer.stop()
		self.disabled = false

func update_button_text():
	# 更新按钮上的文本，显示倒计时秒数
	if countdown_sec > 0:
		self.text = "Get new after " + str(countdown_sec) + " sec"
	else:
		self.text = "Get Active Code"



