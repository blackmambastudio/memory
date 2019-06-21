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

	self.add_dialogue_graph("res://Levels/act1/dlg01.data")
	
	VariableBoard.register("health", 5.5)
	VariableBoard.register("peluca", "modified")
	VariableBoard.register("new_memories", 52)

	# Variables related with the progress of each memory
	VariableBoard.register("id-deep", 0)
	# ---- M01 - Real ----
	VariableBoard.register("1-hijos-deep", 0)
	VariableBoard.register("1-costume-deep", 0)
	VariableBoard.register("1-nariz-deep", 0)
	VariableBoard.register("1-exesposo-deep", 0)
	VariableBoard.register("1-cofre-deep", 0)
	# ---- M02 - Real ----
	VariableBoard.register("1-key-deep", 0)
	VariableBoard.register("1-tv-deep", 0)
	VariableBoard.register("1-window-deep", 0)
	VariableBoard.register("1-cockroach-deep", 0)
	VariableBoard.register("1-etiqueta-deep", 0)
	VariableBoard.register("1-luggage-deep", 0)
	VariableBoard.register("1-newspaper-deep", 0)
	VariableBoard.register("1-phone-deep", 0)
	VariableBoard.register("1-poster-deep", 0)


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
	if not text_object.audio.empty():
		play_sound("res://Audio/AudioAssets/"+text_object.audio)
		pass

func play_sound(audio_file):
	var user_sample = load(audio_file)
	$SoundObjectST.stream = user_sample
	$SoundObjectST.play()


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
	$SoundObjectST.stop()
	ActionRouter.request(_on_timeout_action)

func cls():
	$Panel/Text.text = ""

