extends Control
onready var ActionRouter = get_node("/root/ActionRouter")

const DialogueActions = preload("dialogue_actions.gd")
onready var actionHandler = DialogueActions.new()
var _on_timeout_action = {}

var DialogNode = load("res://Tools/DialogEditor/DialogNode.gd")
var OptionElement = load("res://Tools/DialogEditor/OptionElement.gd")

var dialog_tree = {}
var current_text_id = ''
var waiting_for_user_input = false

func _ready():
	self.actionHandler.set_dialogue(self)
	ActionRouter.register_actions(self.actionHandler)
	$Timer.connect("timeout", self, "timeout")
	self.dialog_tree = self.parse_dialogue(_get_dialogue_schema("res://Levels/test2.data"))

	ActionRouter.request({
		"action":"Dialogue/display",
		"text_id": get_root()
	})


func set_text(text_id):
	self.current_text_id = text_id
	var text_object = self.get_text_object(text_id)
	$Panel/Text.text = text_object.actor + ": " + text_object.text
	$Timer.set_wait_time(text_object.timeout)
	$Timer.start()
	_on_timeout_action = text_object.on_timeout


func _on_item_selected(item):
	if not self.waiting_for_user_input or not $Timer.is_stopped(): return
	
	var dialogue_object = self.get_text_object(self.current_text_id)
	for next in dialogue_object.next:
		var item_candidate = self.get_text_object(next)
		if item_candidate.option.to_lower() == item.to_lower():
			ActionRouter.request({
				"action":"Dialogue/display",
				"text_id": next
			})

func solve(text_id):
	randomize()
	# what to do when a dialogue gets a timeout
	var dialogue_object = get_text_object(text_id)
	var candidates = dialogue_object.next
	if candidates[0].empty():
		ActionRouter.request({
			"action":"Dialogue/cls"
		})
		return
	
	var possible_next = get_text_object(candidates[0])
	
	if possible_next.type == "dialog":
		var next = candidates[randi() % candidates.size()]
		ActionRouter.request({
			"action":"Dialogue/display",
			"text_id": next
		})
		self.waiting_for_user_input = false
		return
	
	if possible_next.type == "option":
		# wait and display the memory
		print("wait for players input")
		self.waiting_for_user_input = true
		return


func get_text_object(text_id):
	return self.dialog_tree[text_id.strip_edges()]

func timeout():
	ActionRouter.request(_on_timeout_action)

func cls():
	$Panel/Text.text = ""

func _get_dialogue_schema(file):
	var dialogue_data = File.new()
	if not dialogue_data.file_exists(file):
		return # Error! We don't have a save to load.
	
	var data = ""
	dialogue_data.open(file, File.READ)
	while not dialogue_data.eof_reached():
		data += dialogue_data.get_line() + "\n"
	return data


func parse_dialogue(dialogue):
	var dialogues = dialogue.split("\n")
	var tree = {}
	for dialogue in dialogues:
		var data = dialogue.split("|")
		if len(data) <= 1: continue
		var object = {}
		if data[1] == 'dialog':
			object = DialogNode._to_tree(dialogue)
		elif data[1] == 'option':
			object = OptionElement._to_tree(dialogue)
		
		tree[data[0]] = object
	
	for key in tree.keys():
		var object = tree[key]
		object["on_timeout"] = {
			"action": "Dialogue/end",
			"text_id": key
		}
	
	return tree

func get_root():
	var nodes = self.dialog_tree.keys()
	for key in self.dialog_tree.keys():
		var node = self.dialog_tree[key]
		for n in node.next:
			nodes.erase(n)
	return nodes[0]


