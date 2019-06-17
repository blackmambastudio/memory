extends GraphNode

export (String) var action = ''

func _ready():
	connect("close_request", self, "_on_control_close_request")
	connect("resize_request", self, "_on_resize_request")
	set_slot(0, true, 0, Color(1,1,1,1), true, 0, Color(0,1,1,1))
	$ActionText.text = self.action
	$ActionText.connect("text_changed", self, "_on_update_text")

func _on_control_close_request():
	queue_free()

func _on_resize_request(new_minsize):
	rect_size = new_minsize

func _on_update_text():
	self.action = $ActionText.text

func _to_string_node(next_nodes):
	return self.name + \
		"|action|" + \
		action.replace('\n','') + '|' + \
		str(next_nodes)

static func _to_tree(string):
	var data = string.split("|")
	return {
		"type": 'action',
		"action": data[2],
		"timeout": 0.1,
		"next": data[3].replace("[", "").replace("]","").split(",")
	}
