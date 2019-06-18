extends Control

var speed = 200
var open = false

func _ready():
	var ActionRouter = get_node("/root/ActionRouter")
	ActionRouter.register_actions(self)

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		$PortionLight.position.x -= speed*delta
	if Input.is_action_pressed("ui_right"):
		$PortionLight.position.x += speed*delta
	if Input.is_action_pressed("ui_up"):
		$PortionLight.position.y -= speed*delta
	if Input.is_action_pressed("ui_down"):
		$PortionLight.position.y += speed*delta

func handle(request):
	match request.action:
		"Memory/show":
			open = request.value
			$AnimationPlayer.play(
				"Show",
				-1, 1.0 if request.value else -1.0,
				!request.value
			)
