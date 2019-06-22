extends Control

var current_view
onready var VariableBoard = get_node("/root/VariableBoard")

export (String) var starting_dialogue = ""

func _ready():
	for child in $Views.get_children():
		if child.visible:
			current_view = child

func change_view(name):
	if current_view:
		current_view.hide()
	current_view = $Views.get_node(name)
	current_view.show()

func start():
	pass

func change_view_background(background_name):
	current_view.set_background(background_name)