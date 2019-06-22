extends Sprite

func _ready():
	if $WindowControl:
		$WindowControl.connect("bg_to_left", $Window, "bg_to_left")
		$WindowControl.connect("bg_to_right", $Window, "bg_to_right")
		$WindowControl.connect("main_to_left", $Window, "main_to_left")
		$WindowControl.connect("main_to_right", $Window, "main_to_right")
		$WindowControl.connect("toggle_item", $Window, "toggle_item")

