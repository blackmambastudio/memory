extends "res://Acts/ChangeViewZone.gd"

signal clicked

func _ready():
	$Outline.visible = false

func _on_hover():
	._on_hover()
	$Outline.visible = true

func _on_exit():
	._on_exit()
	$Outline.visible = false

func _handle_input(viewport, event, idx):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("clicked", self.name)
