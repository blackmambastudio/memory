extends "res://Acts/ChangeViewZone.gd"

signal clicked
signal looked
signal exit
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
	emit_signal("looked", self.name)

func _on_exit():
	._on_exit()
	if outline_set:
		get_node("Outline").visible = false
	emit_signal("exit")

func _handle_input(viewport, event, idx):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("clicked", self.name)
