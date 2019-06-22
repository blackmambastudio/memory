extends Control

export(bool) var skip_on_click = false

onready var arrow = load('res://Assets/Cursor/Arrow.png')
onready var pointing_hand = load('res://Assets/Cursor/PointingHand.png')
onready var ActionRouter = get_node("/root/ActionRouter")
var click_pressed = false

func _ready():
	# Setup actions
	ActionRouter.register_actions(self)

	# Setup the mouse cursor for the game
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(
		pointing_hand,
		Input.CURSOR_POINTING_HAND,
		Vector2(6.0, 0.0)
	)

	# Setup signal listeners
	$Memory/Memory1.connect("item_selected", $DialogueManager, "_on_item_selected")
	$Memory/Memory2.connect("item_selected", $DialogueManager, "_on_item_selected")
	
	# loading the first act
	$ActManager.load_act("res://Acts/Act1/Act1_Room.tscn")

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
