extends "res://Acts/ActScene.gd"

func _ready():
	$Views/KitchenWindow/Window.connect("mood_match", self, "mood_matched")
	$Views/KitchenWindow/Window.connect("mood_match", self, "mood_unmatched")

func mood_matched():
	print("mood matched")
	VariableBoard.set_value("view_lucia_status", "3")
	$Views/KitchenFront.lock_view()
	self.change_view("KitchenFront")

func unmood_matched():
	pass