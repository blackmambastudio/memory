extends "res://Acts/ViewScene.gd"
onready var VariableBoard = get_node("/root/VariableBoard")

func _ready():
	VariableBoard.suscribe("inv_control", self, "unlock_control")
	$WindowControl.visible = VariableBoard.get_value("inv_control")
	$WindowControl.connect("bg_to_left", $Window, "bg_to_left")
	$WindowControl.connect("bg_to_right", $Window, "bg_to_right")
	$WindowControl.connect("main_to_left", $Window, "main_to_left")
	$WindowControl.connect("main_to_right", $Window, "main_to_right")
	$WindowControl.connect("toggle_item", $Window, "toggle_item")

func unlock_control(value):
	$WindowControl.visible = value