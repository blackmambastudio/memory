extends "res://Acts/ViewScene.gd"

var auto_minigame = true
onready var ActionRouter = get_node("/root/ActionRouter")

func _ready():
	to_left()
	pass

func _on_clicked(clickeable_name):
	if clickeable_name == 'Left_action':
		print("do left")
		if auto_minigame:
			$minigames/Auto.stop_car()
	elif clickeable_name == 'Middle_action':
		print("do middle")
		if auto_minigame:
			$minigames/Auto.stop_car()
	elif clickeable_name == 'Right_action':
		print("do action")
		if auto_minigame:
			$minigames/Auto.stop_car()

# display memories on the left
func to_left():
	self.position.x -= 1280/4
	# open memory and clipped it to the left
	
	ActionRouter.request({"action":"Memory/current", "value": 2})
	ActionRouter.request({"action":"Memory/clip_left"})
	#ActionRouter.request({"action":"Memory/show", "value": true})

func to_right():
	self.position.x += 1280/4
	ActionRouter.request({"action":"Memory/current", "value": 2})
	ActionRouter.request({"action":"Memory/clip_right"})
	#ActionRouter.request({"action":"Memory/show", "value": true})
	# open memory and clipped it to the right
	#to test