extends "res://Acts/ViewScene.gd"

onready var ActionRouter = get_node("/root/ActionRouter")

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "change_act")

func change_act(animation):
	ActionRouter.request({
		"action": "Act/show",
		"act": "res://Acts/Act1/Act1_Room.tscn"
	})
	

