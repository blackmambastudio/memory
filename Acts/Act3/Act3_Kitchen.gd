extends "res://Acts/ActScene.gd"

func _ready():
	$Views/KitchenWindow/Window.connect("mood_match", self, "mood_matched")
	$Views/KitchenWindow/Window.connect("mood_unmatch", self, "mood_unmatched")

func mood_matched():
	VariableBoard.set_value("view_lucia_status", "3")
	$Views/KitchenFront.lock_view()
	ActionRouter.request({
	    "action": "Dialogue/stack", "path": "res://Levels/act3/dlg03.data"
	})

func mood_unmatched():
	# ActionRouter.request({
	#     "action": "Dialogue/stack",
	# 	"path": "res://Levels/act3/argh.data"
	# })
	pass