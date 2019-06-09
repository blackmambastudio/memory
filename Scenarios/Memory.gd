extends Control

var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("ui_left"):
		$Light2D.position.x -= speed*delta
	if Input.is_action_pressed("ui_right"):
		$Light2D.position.x += speed*delta
	if Input.is_action_pressed("ui_up"):
		$Light2D.position.y -= speed*delta
	if Input.is_action_pressed("ui_down"):
		$Light2D.position.y += speed*delta