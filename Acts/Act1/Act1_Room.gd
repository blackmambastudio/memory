extends "res://Acts/ActScene.gd"

export(String, "laundry", "appliances", "gardentools", "kitchen") var level = "laundry"

func _ready():
	ActionRouter.request({
	    "action": "Game/Wordsearch/load",
		"level": level
	})
	#$Views/RoomRightFront/SopaLetras.load_level(level)
