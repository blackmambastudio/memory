extends Control


signal bg_to_left
signal bg_to_right
signal main_to_left
signal main_to_right
signal toggle_item

func _ready():
	$BG_Left.connect("button_down", self, "emit_signal", ["bg_to_left"])
	$BG_Right.connect("button_down", self, "emit_signal", ["bg_to_right"])
	$Main_Left.connect("button_down", self, "emit_signal", ["main_to_left"])
	$Main_Right.connect("button_down", self, "emit_signal", ["main_to_right"])
	
	$Button01.connect("button_down", self, "toggle", [0])
	$Button02.connect("button_down", self, "toggle", [1])
	$Button03.connect("button_down", self, "toggle", [2])
	$Button04.connect("button_down", self, "toggle", [3])
	$Button05.connect("button_down", self, "toggle", [4])
	$Button06.connect("button_down", self, "toggle", [5])
	$Button07.connect("button_down", self, "toggle", [6])

func toggle(item):
	emit_signal("toggle_item", item)
	




