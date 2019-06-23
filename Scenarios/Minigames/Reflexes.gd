extends Control

var side_emitted = -1
var current_light

var current_time = 0
var action_time = 0

func _ready():
	$Left.visible = false
	$Right.visible = false
	self.emit_light()

func emit_light():
	side_emitted = -1
	$Timer.start(1.5)
	yield($Timer, "timeout")
	randomize()
	side_emitted = randi()%2
	
	if side_emitted == 0:
		current_light = $Left
	else:
		current_light = $Right
	
	current_light.visible = true
	self.current_time = 0
	$Timer.start(0.05)
	yield($Timer, "timeout")
	current_light.visible = false

func choose_light(side):
	print(self.current_time - self.action_time)
	var correct = side_emitted == side
	return correct

func _process(delta):
	self.current_time += delta
