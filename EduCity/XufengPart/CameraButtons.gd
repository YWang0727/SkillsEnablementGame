extends Node2D

enum direction {right, left, up, down, default}
var moveDirection = direction.default
var border = 1000
@onready var tileMap : Node = get_node("/root/MainScene/TileMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match moveDirection:
		direction.right:
			if tileMap.position.x >= border * -1:
				tileMap.position.x -= 5
		direction.left:
			if tileMap.position.x <= border:
				tileMap.position.x += 5
		direction.up:
			if tileMap.position.x <= border:
				tileMap.position.y += 5
		direction.down:
			if tileMap.position.x >= border * -1:
				tileMap.position.y -= 5
	pass


func _on_right_move_button_button_down():
	moveDirection = direction.right

func _on_right_move_button_button_up():
	moveDirection = direction.default

func _on_left_move_button_button_down():
	moveDirection = direction.left

func _on_left_move_button_button_up():
	moveDirection = direction.default

func _on_up_move_button_button_down():
	moveDirection = direction.up

func _on_up_move_button_button_up():
	moveDirection = direction.default

func _on_down_move_button_button_down():
	moveDirection = direction.down

func _on_down_move_button_button_up():
	moveDirection = direction.default

func _on_center_move_button_pressed():
	tileMap.position.x = 0
	tileMap.position.y = 0
