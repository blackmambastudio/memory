extends "res://Acts/ViewScene.gd"

var auto_minigame = false
var reflexes_minigame = false
onready var ActionRouter = get_node("/root/ActionRouter")
onready var VariableBoard = get_node("/root/VariableBoard")

func _ready():
	# TODO
	# use the variable board to get notified and trigger
	# when to clip to the left, or to the right
	VariableBoard.suscribe("test_split_memory", self, "clip_test")
	VariableBoard.suscribe("view_active_minigame", self, "display_game")
	
	display_game(1)

func display_game(game_type):
	if game_type == 'auto':
		reflexes_minigame = false
		$minigames/Reflexes.visible = false
		auto_minigame = true
		$minigames/Auto.visible = true
		$minigames/Auto.run_car()
	elif game_type == 'reflexes':
		reflexes_minigame = true
		$minigames/Reflexes.visible = true
		auto_minigame = false
		$minigames/Auto.visible = false
		$minigames/Reflexes.emit_light()

func clip_test(value):
	if value == "0":
		to_center()
	elif value == "-1":
		to_left()
	elif value == "1":
		to_right()

func _on_clicked(clickeable_name):
	if clickeable_name == 'Left_action':
		print("do left")
		if auto_minigame:
			$minigames/Auto.stop_car()
		elif reflexes_minigame:
			$minigames/Reflexes.choose_light(0)
			$minigames/Reflexes.emit_light()
	elif clickeable_name == 'Middle_action':
		print("do middle")
		if auto_minigame:
			$minigames/Auto.stop_car()
	elif clickeable_name == 'Right_action':
		print("do action")
		if auto_minigame:
			$minigames/Auto.stop_car()
		elif reflexes_minigame:
			$minigames/Reflexes.choose_light(1)
			$minigames/Reflexes.emit_light()

# display memories on the left
func to_left():
	self.position.x -= 1280/4
	# open memory and clipped it to the left
	
	ActionRouter.request({"action":"Memory/M2/clip_left"})
	#ActionRouter.request({"action":"Memory/show", "value": true})

func to_right():
	self.position.x += 1280/4
	ActionRouter.request({"action":"Memory/M2/clip_right"})
	#ActionRouter.request({"action":"Memory/show", "value": true})
	# open memory and clipped it to the right
	#to test

func to_center():
	self.position.x = 0
	ActionRouter.request({"action":"Memory/M2/restore"})