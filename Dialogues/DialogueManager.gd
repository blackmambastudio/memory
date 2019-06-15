extends Control
onready var ActionRouter = get_node("/root/ActionRouter")

const DialogueActions = preload("dialogue_actions.gd")
onready var actionHandler = DialogueActions.new()
const Dialogue = preload("Dialogue.gd")

var _on_timeout_action = {}
var dialogue_instance

func _ready():
	self.actionHandler.set_dialogue(self)
	ActionRouter.register_actions(self.actionHandler)
	$Timer.connect("timeout", self, "timeout")

	self.dialogue_instance = Dialogue.new("res://Levels/test.data")
	self.dialogue_instance.set_action_router(ActionRouter)
	self.dialogue_instance.start()


func set_text(text_id):
	self.dialogue_instance.set_current_block(text_id)
	var text_object = self.dialogue_instance.get_text_object(text_id)
	$Panel/Text.text = text_object.actor + ": " + text_object.text_en
	$Timer.set_wait_time(text_object.timeout)
	$Timer.start()
	_on_timeout_action = text_object.on_timeout

func _on_item_selected(item):
	if not $Timer.is_stopped(): return
	self.dialogue_instance._on_item_selected(item)

func solve():
	self.dialogue_instance.solve()


func timeout():
	ActionRouter.request(_on_timeout_action)

func cls():
	$Panel/Text.text = ""

