extends Control

var current_view
onready var VariableBoard = get_node("/root/VariableBoard")

export (String) var starting_dialogue = ''

var Pan

func _ready():
	Pan = AudioServer.get_bus_effect(1,0)
	for child in $Views.get_children():
		if child.visible:
			current_view = child

func change_view(name):
	if current_view:
		current_view.hide()
	current_view = $Views.get_node(name)
	current_view.show()
	if name == 'RoomLeft':
		Pan.set_pan(0.4)
		$WindowSound.position.x = 1350
	if name == 'RoomFront':
		Pan.set_pan(0)
		$WindowSound.position.x = 1138
	if name == 'RoomRightFront':
		Pan.set_pan(-0.4)
		$WindowSound.position.x = 900
	if name == 'RoomRight':
		Pan.set_pan(-0.7)
		$WindowSound.position.x = 620

func start():
	pass

func change_view_background(background_name):
	current_view.set_background(background_name)