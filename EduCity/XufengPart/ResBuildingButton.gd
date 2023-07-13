extends Button

var lock = load("res://XufengPart/Icon_Buildings/locked.png")
var bank = load("res://XufengPart/Icon_Buildings/Bank/bank_1.png")
var farm = load("res://XufengPart/Icon_Buildings/Farm/farm_1.png")
var hospital = load("res://XufengPart/Icon_Buildings/Hospital/hospital_1.png")
var residential = load("res://XufengPart/Icon_Buildings/Residential Building/residential building_2.png")
var supermarket = load("res://XufengPart/Icon_Buildings/Supermarket/supermarket_1.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if IfLock.Residential == 1:
		icon = residential
	else:
		icon = lock
		

