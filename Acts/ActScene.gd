extends Control

var current_view

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

