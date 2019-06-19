extends Control

var side_emitted = -1
var current_light

func _ready():
	self.emit_light()

func emit_light():
	side_emitted = -1
	$Timer.start(2)
	yield($Timer, "timeout")
	randomize()
	side_emitted = randi()%2
	var light_index = randi()%3
	if side_emitted == 0:
		current_light = $Left.get_child(light_index)
	else:
		current_light = $Right.get_child(light_index)
	
	current_light.visible = true
	$Timer.start(0.1)
	yield($Timer, "timeout")
	current_light.visible = false

func choose_light(side):
	return side_emitted == side

func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		print(self.choose_light(0))
		self.emit_light()
	if Input.is_action_just_pressed("ui_right"):
		print(self.choose_light(1))
		self.emit_light()
	
	

