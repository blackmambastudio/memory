extends Control
onready var ActionRouter = get_node("/root/ActionRouter")
onready var VariableBoard = get_node("/root/VariableBoard")

const DialogueActions = preload("dialogue_actions.gd")
onready var actionHandler = DialogueActions.new()
const Dialogue = preload("Dialogue.gd")

var _on_timeout_action = {}
var dialogue_instance
var dialogue_stack = []

func _ready():
	self.actionHandler.set_dialogue(self)
	ActionRouter.register_actions(self.actionHandler)
	$Timer.connect("timeout", self, "timeout")

	self.add_dialogue_graph("res://Levels/test.data")
	
	VariableBoard.register("health", 5.5)
	VariableBoard.register("peluca", "modified")


func add_dialogue_graph(path_file):
	var dialogue_graph = Dialogue.new(path_file)
	dialogue_graph.set_action_router(ActionRouter)
	dialogue_graph.set_variable_board(VariableBoard)
	dialogue_graph.connect("finish", self, "_on_dialogue_finished")
	self.dialogue_stack.append(dialogue_graph)
	self.dialogue_instance = dialogue_graph
	self.dialogue_instance.start()

func _on_dialogue_finished():
	print("the dialog is finished")
	self.cls()
	if len(self.dialogue_stack) > 1:
		self.dialogue_stack.pop_back()
		self.dialogue_instance = self.dialogue_stack[-1]
		self.dialogue_instance.resume()
	

func set_text(text_id):
	self.dialogue_instance.set_current_block(text_id)
	var text_object = self.dialogue_instance.get_text_object(text_id)
	self.set_text_object(text_object)

func set_text_object(text_object):
	$Panel/Text.text = text_object.actor + ": " + text_object.text_en
	$Timer.set_wait_time(text_object.timeout)
	$Timer.start()
	_on_timeout_action = text_object.on_timeout

func _on_item_selected(item):
	if not $Timer.is_stopped(): return
	self.dialogue_instance._on_item_selected(item)

func solve_next():
	self.dialogue_instance.solve_next()


func timeout():
	ActionRouter.request(_on_timeout_action)

func cls():
	$Panel/Text.text = ""

