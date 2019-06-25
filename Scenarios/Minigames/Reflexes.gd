extends Control

signal test_done(win)

var side_emitted = -1
var current_light
var current_time = 0
var action_time = 0
var well_done = 0
var emitting = false

func _ready():
	$Left.visible = false
	$Right.visible = false
	self.emit_light()

func start_emitting():
	emitting = true
	self.emit_light()

func emit_light():
	if not emitting:
		return

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
	$Timer.start(0.5)
	yield($Timer, "timeout")
	current_light.visible = false

func choose_light(side):
	print(self.current_time - self.action_time)
	var correct = side_emitted == side
	if correct:
		well_done += 1
		if well_done >= 3:
			emit_signal("test_done", true)
			emitting = false
			well_done = 0
	else:
		emit_signal("test_done", false)
		emitting = false
		well_done = 0
	# return correct

func _process(delta):
	self.current_time += delta