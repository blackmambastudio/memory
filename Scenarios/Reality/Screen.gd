extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$WindowControl.connect("bg_to_left", $Window, "bg_to_left")
	$WindowControl.connect("bg_to_right", $Window, "bg_to_right")
	$WindowControl.connect("main_to_left", $Window, "main_to_left")
	$WindowControl.connect("main_to_right", $Window, "main_to_right")
	$WindowControl.connect("toggle_item", $Window, "toggle_item")

