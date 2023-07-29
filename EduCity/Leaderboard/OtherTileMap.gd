extends TileMap

var buildingLayer: int = 2




# Called when the node enters the scene tree for the first time.
func _ready():
	HttpLayer.connect("http_completed", http_completed)
	HttpLayer._otherMap()
	
	
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func http_completed(res, response_code, headers, route):
	#if token is checked and valid, return true
	if !AlertPopup.tokenCheck(res):
		return	
		
	if route == "otherMap":
		for i in range(0, res.num):
			var cellPos_temp
			cellPos_temp = local_to_map(position)
			cellPos_temp.x = res.x[i]
			cellPos_temp.y = res.y[i]
			set_cell(buildingLayer,cellPos_temp,res.houseType[i],Vector2i(0,0))
			

