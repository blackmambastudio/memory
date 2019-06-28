extends "res://Acts/ViewScene.gd"

onready var ActionRouter = get_node("/root/ActionRouter")

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "change_act")

func change_act(animation):
	ActionRouter.request({
		"action": "Act/end",
		"next": "res://Acts/Act5/Act5.tscn"
	})
