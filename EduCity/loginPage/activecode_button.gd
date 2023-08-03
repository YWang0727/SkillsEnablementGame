extends Button

var countdown_sec = 60
var timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _ready():
	# 创建一个定时器实例
	timer = $Timer
	# 将定时器的 timeout 信号连接到 _on_timer_timeout 方法
	timer.connect("timeout", self, "_on_timer_timeout")
	# 将定时器添加到场景树
	add_child(timer)

func _on_button_pressed():
	# 点击按钮后，开始倒计时并禁用按钮
	start_countdown()

func start_countdown():
	# 启动定时器，每秒更新按钮上的文本
	timer.start(1.0)
	countdown_sec = 60
	update_button_text()
	set_disabled(true)

func _on_timer_timeout():
	# 定时器时间到，每秒更新按钮上的文本
	countdown_sec -= 1
	update_button_text()

	# 如果倒计时完成，停止定时器并启用按钮
	if countdown_sec <= 0:
		timer.stop()
		set_disabled(false)

func update_button_text():
	# 更新按钮上的文本，显示倒计时秒数
	if countdown_sec > 0:
		text = "倒计时 " + str(countdown_sec) + " 秒"
	else:
		text = "获取验证码"
	set_text(text)
