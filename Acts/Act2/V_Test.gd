extends "res://Acts/ViewScene.gd"

var auto_minigame = false
var reflexes_minigame = false
onready var ActionRouter = get_node("/root/ActionRouter")
onready var VariableBoard = get_node("/root/VariableBoard")

func _ready():
	# Set listeners for board variables
	VariableBoard.suscribe("test_split_memory", self, "clip_test")
	VariableBoard.suscribe("view_active_minigame", self, "display_game")
	VariableBoard.suscribe("start_active_minigame", self, "start_minigame")

	# Connect signal listeners
	$minigames/Auto.connect("test_done", self, "_on_minigame_finish")
	$minigames/Reflexes.connect("test_done", self, "_on_minigame_finish")

func display_game(game_type):
	if game_type == 'auto':
		reflexes_minigame = false
		$minigames/Reflexes.visible = false
		auto_minigame = true
		$minigames/Auto.visible = true
		# $minigames/Auto.run_car()
	elif game_type == 'reflexes':
		reflexes_minigame = true
		$minigames/Reflexes.visible = true
		auto_minigame = false
		$minigames/Auto.visible = false
		# $minigames/Reflexes.emit_light()

func start_minigame(value):
	if auto_minigame:
		$minigames/Auto.run_car()
	elif reflexes_minigame:
		$minigames/Reflexes.start_emitting()

func clip_test(value):
	if value == "0":
		to_center()
	elif value == "-1":
		to_left()
	elif value == "1":
		to_right()

func _on_clicked(clickeable_name):
	if clickeable_name == 'Left_action':
		if auto_minigame:
			$minigames/Auto.stop_car()
		elif reflexes_minigame:
			$minigames/Reflexes.choose_light(0)
			$minigames/Reflexes.emit_light()
	elif clickeable_name == 'Middle_action':
		if auto_minigame:
			$minigames/Auto.stop_car()
	elif clickeable_name == 'Right_action':
		if auto_minigame:
			$minigames/Auto.stop_car()
		elif reflexes_minigame:
			$minigames/Reflexes.choose_light(1)
			$minigames/Reflexes.emit_light()

# display memories on the left
func to_left():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position",
	        Vector2(0,0), Vector2(-1280/4, 0), 0.3,
	        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	# open memory and clipped it to the left
	
	ActionRouter.request({"action":"Memory/M2/clip_left"})
	#ActionRouter.request({"action":"Memory/show", "value": true})

func to_right():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position",
	        Vector2(0,0), Vector2(1280/4, 0), 0.3,
	        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	ActionRouter.request({"action":"Memory/M2/clip_right"})
	#ActionRouter.request({"action":"Memory/show", "value": true})
	# open memory and clipped it to the right
	#to test

func to_center():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position",
	        Vector2(self.position.x, 0), Vector2(0, 0), 0.3,
	        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	ActionRouter.request({"action":"Memory/M2/restore"})

func _on_minigame_finish(win):
	if win:
		ActionRouter.request({
			"action": "Dialogue/stack",
			"path": "res://Levels/nick_tests/question.data"
		})
	else:
		# TODO: Trigger a regaño
		if auto_minigame:
			$minigames/Auto.run_car()
		elif reflexes_minigame:
			$minigames/Reflexes.emit_light()