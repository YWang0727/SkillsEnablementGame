extends Panel

signal update_components

var getGolds = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	if _ifGoldCanGet():
		for cellPos in GameManager.mapDict:
			if GameManager.mapDict[cellPos]["finish_time"] == 0:
				var houseType = GameManager.mapDict[cellPos]["house_type"]
				if houseType == GameManager.BuildingType.supermarket_1:
					getGolds += 100
				elif houseType == GameManager.BuildingType.supermarket_2:
					getGolds += 200
				elif houseType == GameManager.BuildingType.supermarket_3:
					getGolds += 400
				elif houseType == GameManager.BuildingType.bank_1:
					getGolds += 300
				elif houseType == GameManager.BuildingType.bank_2:
					getGolds += 600
				elif houseType == GameManager.BuildingType.bank_3:
					getGolds += 1200
	if getGolds > 0:
		var label = get_node("label")
		label.text = "You've completed another day\nand earned " + str(getGolds) + " golds!"
		self.show()


func _on_ok_pressed():
	# after picking up golds, update golds amount
	GameManager.gold += getGolds
	var nowUnixTime:int = Time.get_unix_time_from_system()
	GameManager.gold_get_time = nowUnixTime
	var _credential = {
		"id": GameManager.user_id,
		"gold": GameManager.gold,
		"gold_get_time": GameManager.gold_get_time
	}
	HttpLayer._pushComponents(_credential)
	emit_signal("update_components")
	self.hide()


func _ifGoldCanGet() -> bool:
	if GameManager.gold_get_time == 0:
		return true
	else:
		# Calculate the next target time when the player can get golds
		# Target time is everday's 05:00:00
		var targetDateTime = Time.get_datetime_dict_from_unix_time(GameManager.gold_get_time)
		if targetDateTime.hour >= 5:
			targetDateTime.day += 1
		targetDateTime.hour = 5
		targetDateTime.minute = 0
		targetDateTime.second = 0
		var targetUnixTime:int = Time.get_unix_time_from_datetime_dict(targetDateTime)
		var nowUnixTime:int = Time.get_unix_time_from_system()
		if nowUnixTime >= targetUnixTime:
			return true
	return false

