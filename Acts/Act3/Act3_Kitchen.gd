extends "res://Acts/ActScene.gd"

func _ready():
	$Views/KitchenWindow/Window.connect("mood_match", self, "mood_matched")
	$Views/KitchenWindow/Window.connect("mood_match", self, "mood_unmatched")

func mood_matched():
	VariableBoard.set_value("view_lucia_status", "3")
	$Views/KitchenFront.lock_view()
	self.change_view("KitchenFront")
	ActionRouter.request({
	    "action": "Dialogue/stack", "path": "res://Levels/act3/dlg03.data"
	})

func unmood_matched():
	pass