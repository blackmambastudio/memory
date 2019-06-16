extends GraphNode

export (String) var variable = ''
export (int) var condition_index = 0
export (String) var value = ''

var options = ["equals", "greater", "less", "default"]

func _ready():
	connect("close_request", self, "_on_control_close_request")
	connect("resize_request", self, "_on_resize_request")
	set_slot(0, true, 0, Color(1,1,1,1), true, 0, Color(0,1,1,1))
	
	for option in options:
		$Condition.add_item(option)
	
	$Variable.text = self.variable
	$Condition.select(condition_index)
	$Value.text = self.value
	
	$Variable.connect("text_changed", self, "_on_update_text")
	$Condition.connect("item_selected", self, "_on_set_option")
	$Value.connect("text_changed", self, "_on_update_text")


func _on_control_close_request():
	queue_free()


func _on_resize_request(new_minsize):
	rect_size = new_minsize


func _on_update_text():
	self.variable = $Variable.text
	self.value = $Value.text
	self.update_title()


func _on_set_option(id):
	self.condition_index = id
	self.update_title()


func update_title():
	self.title = 'Filter - ' + self.variable + " " + options[self.condition_index] + " " + self.value


func _to_string_node(next_nodes):
	return self.name + \
		"|filter|" + \
		variable + '|' + \
		options[condition_index] + '|' + \
		value + '|' + \
		str(next_nodes)


static func _to_tree(string):
	var data = string.split("|")
	return {
		"type": 'filter',
		"variable": data[2],
		"condition": data[3],
		"value": data[4],
		"timeout": 0.1,
		"next": data[5].replace("[", "").replace("]","").split(",")
	}
