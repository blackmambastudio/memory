extends "res://Tools/DialogEditor/DialogNode.gd"

export (int) var option_selected = 0

var options = [
	"peluca",
	"id",
	"costume"
]

func _ready():
	$OptionButton.clear()
	for option in options:
		$OptionButton.add_item(option)
	
	$OptionButton.select(self.option_selected)
	
	$OptionButton.select(self.option_selected)
	$OptionButton.connect("item_selected", self, "_on_set_option")

func _on_set_option(id):
	self.option_selected = id

func _to_string_node(next_nodes):
	return self.name + \
		"|option|" +  \
		self.actors[self.actor_selected] + '|' + \
		self.options[self.option_selected] + '|' + \
		self.en_text + "|" + \
		self.es_text  + "|" + \
		str(next_nodes)

static func _to_tree(string):
	var data = string.split("|")
	return {
		"type": data[1],
		"actor": data[2],
		"option": data[3],
		"text": data[4],
		"timeout": 1,
		"next": data[6].replace("[", "").replace("]","").split(",")
	}