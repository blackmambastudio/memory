class_name DialogueParser

const DialogNode = preload("res://Tools/DialogEditor/DialogNode.gd")
const OptionElement = preload("res://Tools/DialogEditor/OptionElement.gd")
const EmbeddedGraph = preload("res://Tools/DialogEditor/EmbeddedDialogue.gd")
const FilterNode = preload("res://Tools/DialogEditor/FilterNode.gd")

static func _get_dialogue_schema(file):
	var dialogue_data = File.new()
	if not dialogue_data.file_exists(file):
		return # Error! We don't have a save to load.
	
	var data = ""
	dialogue_data.open(file, File.READ)
	while not dialogue_data.eof_reached():
		data += dialogue_data.get_line() + "\n"
	return data

static func parse_dialogue(file):
	var dialogue = _get_dialogue_schema(file)
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
		elif data[1] == 'embedded':
			object = EmbeddedGraph._to_tree(dialogue)
		elif data[1] == 'filter':
			object = FilterNode._to_tree(dialogue)
		object["id"] = data[0]
		tree[data[0]] = object
	
	for key in tree.keys():
		var object = tree[key]
		object["on_timeout"] = {
			"action": "Dialogue/end",
			"text_id": key
		}
	
	return tree