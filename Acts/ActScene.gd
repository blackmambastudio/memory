extends Control

var current_view
onready var VariableBoard = get_node("/root/VariableBoard")

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
	print("start not implemented yet")
	pass

func change_view_background(background_name):
	current_view.set_background(background_name)