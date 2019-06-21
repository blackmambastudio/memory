extends Area2D

var hovered = false
var input_enabled = false
onready var ActionRouter = get_node("/root/ActionRouter")
export (String) var to_view = ''

func _ready():
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_exit")
	connect("input_event", self, "_handle_input")

func _on_hover():
	hovered = true

func _on_exit():
	hovered = true

func _handle_input(viewport, event, idx):
	if event is InputEventMouseButton:
		if event.pressed:
			ActionRouter.request({
				"action": "Act/Views/change",
				"view": to_view
			})

func set_input_enabled(enabled):
	input_enabled = enabled
