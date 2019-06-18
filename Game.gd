extends Control

onready var arrow = load('res://Assets/Cursor/Arrow.png')
onready var pointing_hand = load('res://Assets/Cursor/PointingHand.png')
onready var ActionRouter = get_node("/root/ActionRouter")
var click_pressed = false

func _ready():
	# Setup the mouse cursor for the game
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(
		pointing_hand,
		Input.CURSOR_POINTING_HAND,
		Vector2(6.0, 0.0)
	)

	# Setup signal listeners
	$Memory/Canvas.connect("item_selected", $DialogueManager, "_on_item_selected")

#func _process(delta):
#	if not click_pressed and not $Memory.open \
#		and  Input.is_mouse_button_pressed(BUTTON_LEFT):
#		print("NEXT!")
#		click_pressed = true
#		ActionRouter.request({
#			"action": "Dialogue/next"
#		})
#		yield(get_tree().create_timer(0.1), "timeout")
#		click_pressed = false