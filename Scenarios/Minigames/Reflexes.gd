extends Control

signal test_done(win)

var side_emitted = -1
var current_light
var current_time = 0
var action_time = 0
var well_done = 0
var emitting = false

func _ready():
	self.emit_light()

func start_emitting():
	emitting = true
	$Left.hide()
	$Right.hide()
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
	
	current_light.show()
	$SFX_Emit.playsound()
	self.current_time = 0
	$Timer.start(0.5)
	yield($Timer, "timeout")
	current_light.hide()

func choose_light(side):
	var reflex_time = self.current_time - self.action_time
	var correct = side_emitted == side
	print("Reflex time: ", reflex_time)
	if correct and reflex_time <= 1.5:
		well_done += 1
		if well_done >= 3:
			emitting = false
			well_done = 0
			$SFX_Pos.playsound()
			emit_signal("test_done", true)
	else:
		$SFX_Neg.playsound()
		emitting = false
		well_done = 0
		emit_signal("test_done", false)

func _process(delta):
	self.current_time += delta