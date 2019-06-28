extends "res://Acts/ActScene.gd"

export(String, "laundry", "appliances", "gardentools", "kitchen") var level = "laundry"

func _ready():
	$Views/RoomRightFront/SopaLetras.load_level(level)
