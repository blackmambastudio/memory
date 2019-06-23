extends Control

export(bool) var skip_on_click = false

onready var arrow = load('res://Assets/Cursor/Arrow.png')
onready var pointing_hand = load('res://Assets/Cursor/PointingHand.png')
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

	# Setup signal listeners
	$Memory/Memory1.connect("item_selected", $DialogueManager, "_on_item_selected")
	$Memory/Memory2.connect("item_selected", $DialogueManager, "_on_item_selected")
	
	# setup signal for intro
	$IntroScene/Start.connect("button_down", self, "start_game")
	$IntroScene/Language.connect("button_down", self, "change_language")
	# loading the first act
	#

func start_game():
	$IntroScene.hide()
	$ActManager.load_act("res://Acts/Act4/Act4_Office.tscn")

func change_language():
	var current = VariableBoard.get_value('language')
	if current == 'text_en':
		current = 'text_es'
		$IntroScene/Language.text = '< Español >'
		$IntroScene/Start.text = '< Comenzar >'
	elif current == 'text_es':
		current = 'text_en'
		$IntroScene/Language.text = '< English >'
		$IntroScene/Start.text = '< Start >'
	VariableBoard.set_value('language', current)

func _process(delta):
	if skip_on_click and not click_pressed and not $Memory.open \
		and  Input.is_mouse_button_pressed(BUTTON_LEFT):
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
			$DialogueManager.toggle_text_background(false)
			# $AnimationPlayer.play("FadeIn")
		"Game/ToNormal":
			$Overlay.hide()
			# $AnimationPlayer.play("FadeOut")
