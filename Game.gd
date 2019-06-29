extends Control

export(bool) var skip_with_s = false

onready var arrow = load('res://Assets/Cursor/arrow.png')
onready var pointing_hand = load('res://Assets/Cursor/pointing_hand.png')
onready var turn_left = load('res://Assets/Cursor/turn_left.png')
onready var turn_right = load('res://Assets/Cursor/turn_right.png')
onready var pc_arrow = load('res://Assets/Cursor/pc_arrow.png')
onready var pc_pointing_hand = load('res://Assets/Cursor/pc_pointing_hand.png')
onready var ActionRouter = get_node("/root/ActionRouter")
onready var VariableBoard = get_node("/root/VariableBoard")

var click_pressed = false

func _ready():
	# Setup actions
	ActionRouter.register_actions(self)
	VariableBoard.register("language", "text_en")
	VariableBoard.suscribe('language', $DialogueManager, 'set_language')
	VariableBoard.register("random", randi())
	VariableBoard.register("remember_times", 0)
	VariableBoard.register("memories_replaced", 0)
	

	# Setup the mouse cursor for the game
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(
		pointing_hand,
		Input.CURSOR_POINTING_HAND,
		Vector2(6.0, 0.0)
	)
	Input.set_custom_mouse_cursor(pc_arrow, Input.CURSOR_CROSS)
	Input.set_custom_mouse_cursor(
		pc_pointing_hand,
		Input.CURSOR_DRAG,
		Vector2(7.0, 0.0)
	)
	Input.set_custom_mouse_cursor(turn_left, Input.CURSOR_BDIAGSIZE)
	Input.set_custom_mouse_cursor(turn_right, Input.CURSOR_FDIAGSIZE)

	# Setup signal listeners
	$Memory/Memory1.connect("item_selected", $DialogueManager, "_on_item_selected")
	$Memory/Memory2.connect("item_selected", $DialogueManager, "_on_item_selected")
	
	# setup signal for intro
	$IntroScene/Start.connect("button_down", self, "start_game")
	$IntroScene/Language.connect("button_down", self, "change_language")

func start_game():
	$IntroScene/AnimationPlayer.play("close")
	yield($IntroScene/AnimationPlayer, "animation_finished")
	$IntroScene.hide()
	$IntroScene/Music/MX_Menu.stop()
	$ActManager.load_act()

func change_language():
	var current = VariableBoard.get_value('language')
	if current == 'text_en':
		current = 'text_es'
		$IntroScene/Language.text = '< ESPAÑOL >'
		$IntroScene/Start.text = 'INICIAR'
	elif current == 'text_es':
		current = 'text_en'
		$IntroScene/Language.text = '< ENGLISH >'
		$IntroScene/Start.text = 'START'
	VariableBoard.set_value('language', current)

func _process(delta):
	if skip_with_s and not $IntroScene.is_visible() \
		and not click_pressed and Input.is_key_pressed(KEY_S):
		click_pressed = true
		ActionRouter.request({
			"action": "Dialogue/next"
		})
		yield(get_tree().create_timer(0.1), "timeout")
		click_pressed = false

func handle(request):
	match request.action:
		"Game/ToBlack":
			$Overlay.show()
			$AnimationPlayer.play("FadeIn")
			yield($AnimationPlayer, "animation_finished")
		"Game/ToNormal":
			$AnimationPlayer.play("FadeOut")
			yield($AnimationPlayer, "animation_finished")
			$Overlay.hide()
		"Game/Inyection":
			$Overlay.show()
			$AnimationPlayer.play("Inyection")
			yield($AnimationPlayer, "animation_finished")
			$Overlay.hide()
		"Game/Wait":
			yield(get_tree().create_timer(request.wait), "timeout")
		"Game/Random":
			randomize()
			var new_random = randi() % 100 + 1
			print("new_random >> ", new_random)
			VariableBoard.set_value("random", new_random)
		_:
			return false
#warning-ignore:unreachable_code
	return true
