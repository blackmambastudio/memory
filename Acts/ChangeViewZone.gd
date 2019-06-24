extends Area2D

var hovered = false
var input_enabled = false
onready var ActionRouter = get_node("/root/ActionRouter")
export (String) var to_view = ''
export (String, "left", "right", "hand", "arrow") var cursor_type = "arrow"

func _ready():
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_exit")
	connect("input_event", self, "_handle_input")

func _on_hover():
	match cursor_type:
		"left":
			Input.set_default_cursor_shape(Input.CURSOR_BDIAGSIZE)
		"right":
			Input.set_default_cursor_shape(Input.CURSOR_FDIAGSIZE)
		"hand":
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		_:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	hovered = true

func _on_exit():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
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
