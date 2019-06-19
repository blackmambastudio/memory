extends Control

var current_time = 0
var action_time = 0

func _ready():
	self.display_image()

func display_image():
	randomize()
	$Timer.start(randf()*3 + 2)
	yield($Timer, "timeout")
	self.action_time = self.current_time
	$Panel.rect_position.x = 50 + randi()%400
	$Panel.rect_position.y = 50 + randi()%500
	$Panel.visible = true
	$Timer.start(0.1)
	yield($Timer, "timeout")
	$Panel.visible = false

func _process(delta):
	self.current_time += delta
	if Input.is_action_just_pressed("ui_accept"):
		print(self.current_time - self.action_time)
		self.display_image()
