tool
extends GraphNode

export (String) var en_text = 'put your dialogue here'
export (String) var es_text = 'tu dialogo aquí'
export (int) var actor_selected = 0

var actors = [
	'Cecilia',
	'Dr Nick',
	'Lucia',
	'Claire'
]

func _ready():
	connect("close_request", self, "_on_control_close_request")
	connect("resize_request", self, "_on_resize_request")
	set_slot(0, true, 0, Color(1,1,1,1), true, 0, Color(0,1,1,1))
	$dialog_en.text = self.en_text
	$dialog_es.text = self.es_text
	$dialog_en.connect("text_changed", self, "_on_update_text")
	$dialog_es.connect("text_changed", self, "_on_update_text")
	$actor.clear()
	for actor in actors:
		$actor.add_item(actor)
		
	$actor.select(self.actor_selected)
	$actor.connect("item_selected", self, "_on_set_actor")


func _on_control_close_request():
	queue_free()

func _on_resize_request(new_minsize):
	rect_size = new_minsize

func _on_update_text():
	self.en_text = $dialog_en.text
	self.es_text = $dialog_es.text

func _on_set_actor(id):
	self.actor_selected = id

func _to_string_node(next_nodes):
	return self.name + "|dialog|" + actors[self.actor_selected] + '|' + self.en_text + "|" + self.es_text + "|" + str(next_nodes)

static func _to_tree(string):
	var data = string.split("|")
	return {
		"type": data[1],
		"actor": data[2],
		"text": data[3],
		"timeout": 2,
	"next": data[5].replace("[", "").replace("]","").split(",")
	}
