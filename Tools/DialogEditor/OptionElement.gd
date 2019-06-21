extends GraphNode

export (int) var option_selected = 0

var options = [
	"nariz",
	"id",
	"costume",
	"nariz",
	"hijos",
	"exesposo",
	"cofre",
	"other"
]

func _ready():
	$OptionButton.clear()
	for option in options:
		$OptionButton.add_item(option)
	
	$OptionButton.select(self.option_selected)
	
	self.title = 'Memory - ' + options[self.option_selected]
	$OptionButton.connect("item_selected", self, "_on_set_option")

func _on_set_option(id):
	self.option_selected = id
	self.title = 'Memory - ' + options[id]

func _to_string_node(next_nodes):
	return self.name + \
		"|option|" +  \
		self.options[self.option_selected] + '|' + \
		str(next_nodes)

static func _to_tree(string):
	var data = string.split("|")
	return {
		"type": data[1],
		"option": data[2],
		"next": data[3].replace("[", "").replace("]","").split(",")
	}