extends "res://Acts/ChangeViewZone.gd"

signal clicked
var outline_set = false

func _ready():
	outline_set = has_node("Outline")
	if outline_set:
		var Outline = get_node("Outline")
		Outline.visible = false

func _on_hover():
	._on_hover()
	if outline_set:
		get_node("Outline").visible = true

func _on_exit():
	._on_exit()
	if outline_set:
		get_node("Outline").visible = false

func _handle_input(viewport, event, idx):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("clicked", self.name)
