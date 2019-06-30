extends Control

var current_view
onready var VariableBoard = get_node("/root/VariableBoard")

export (String) var starting_dialogue = ''
export (Array) var pan_values
export (bool) var behind = false

var Pan
var Filter




func _ready():
	Pan = AudioServer.get_bus_effect(1,0)
	Filter = AudioServer.get_bus_effect(1,1)
	Pan.set_pan(0)
	Filter.set_cutoff(11000)
	for child in $Views.get_children():
		if child.visible:
			current_view = child

func change_view(name):
	if current_view:
		current_view.hide()
	current_view = $Views.get_node(name)
	current_view.show()
	if name == 'RoomLeft':
		if behind:
			Filter.set_cutoff(11000)
		Pan.set_pan(pan_values[0])
		$WindowSound.position.x = 1350
	if name == 'RoomFront':
		if behind:
			Filter.set_cutoff(11000)
		Pan.set_pan(pan_values[1])
		$WindowSound.position.x = 1138
	if name == 'RoomRightFront':
		if behind:
			Filter.set_cutoff(9000)
		Pan.set_pan(pan_values[3])
		Pan.set_pan(pan_values[2])
		$WindowSound.position.x = 900
	if name == 'RoomRight':
		if behind:
			Filter.set_cutoff(7000)
		Pan.set_pan(pan_values[3])
		$WindowSound.position.x = 620
	#ACA VA PA KITCHEN
	if name == 'KitchenLeft':
		if behind:
			Filter.set_cutoff(11000)
		Pan.set_pan(pan_values[0])
		#$WindowSound.position.x = 1350
	if name == 'KitchenFront':
		if behind:
			Filter.set_cutoff(11000)
		Pan.set_pan(pan_values[1])
		#$WindowSound.position.x = 1138
	if name == 'KitchenRight':
		if behind:
			Filter.set_cutoff(9000)
		Pan.set_pan(pan_values[3])
		Pan.set_pan(pan_values[2])
		#$WindowSound.position.x = 900
	if name == 'KitchenWindow':
		if behind:
			Filter.set_cutoff(7000)
		Pan.set_pan(pan_values[3])
		#$WindowSound.position.x = 620

func start():
	pass

func change_view_background(background_name):
	current_view.set_background(background_name)