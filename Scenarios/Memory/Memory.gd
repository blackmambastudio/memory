extends Control

var speed = 200

func _ready():
	pass


func _process(delta):
	if Input.is_action_pressed("ui_left"):
		$PortionLight.position.x -= speed*delta
	if Input.is_action_pressed("ui_right"):
		$PortionLight.position.x += speed*delta
	if Input.is_action_pressed("ui_up"):
		$PortionLight.position.y -= speed*delta
	if Input.is_action_pressed("ui_down"):
		$PortionLight.position.y += speed*delta
	
