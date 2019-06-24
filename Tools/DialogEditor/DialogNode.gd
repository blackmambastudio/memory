tool
extends GraphNode

export (String) var en_text = 'put your dialogue here'
export (String) var es_text = 'tu dialogo aquí'
export (String) var audio_resource = ''
export (float) var dx_volume = 0
export (int) var actor_selected = 0
export (float) var timeout = 2.0
export (int) var view_status = 0

var actors = [
	'Cecilia',
	'Dr Nick',
	'Lucia',
	'Claire',
	'Customer',
	'Monteasalvo CS',
	'Pensamiento'
]

func _ready():
	connect("close_request", self, "_on_control_close_request")
	connect("resize_request", self, "_on_resize_request")
	set_slot(0, true, 0, Color(1,1,1,1), true, 0, Color(0,1,1,1))
	$dialog_en.text = self.en_text
	$dialog_es.text = self.es_text
	$audio_file.text = self.audio_resource
	$dx_volume.value = self.dx_volume
	$timeout.value = self.timeout
	$view_status.value = self.view_status
	
	$dialog_en.connect("text_changed", self, "_on_update_text")
	$dialog_es.connect("text_changed", self, "_on_update_text")
	$audio_file.connect("text_changed", self, "_on_update_text")
	$dx_volume.connect("value_changed", self, "_on_update_volume")
	$timeout.connect("value_changed", self, "_on_update_timeout")
	$view_status.connect("value_changed", self, "_on_update_view_status")
	
	$actor.clear()
	for actor in actors:
		$actor.add_item(actor)
		
	$actor.select(self.actor_selected)
	self.title = 'conversation - ' + actors[self.actor_selected]
	$actor.connect("item_selected", self, "_on_set_actor")


func _on_control_close_request():
	queue_free()

func _on_resize_request(new_minsize):
	rect_size = new_minsize

func _on_update_text():
	self.en_text = $dialog_en.text
	self.es_text = $dialog_es.text
	self.audio_resource = $audio_file.text

func _on_update_timeout(value):
	self.timeout = value

func _on_update_volume(value):
	self.dx_volume = value

func _on_update_view_status(value):
	self.view_status = value

func _on_set_actor(id):
	self.actor_selected = id
	self.title = 'conversation - ' + actors[id]

func _to_string_node(next_nodes):
	return self.name + \
		"|dialog|" + \
		actors[self.actor_selected] + '|' + \
		str(self.view_status) + '|' + \
		self.en_text + "|" + \
		self.es_text + "|" + \
		str(self.timeout)+ "|" + \
		self.audio_resource + "|" + \
		str(self.dx_volume) + "|" + \
		str(next_nodes)

static func _to_tree(string):
	var data = string.split("|")
	return {
		"type": data[1],
		"actor": data[2],
		"view_status": data[3],
		"text_en": data[4],
		"text_es": data[5],
		"timeout": float(data[6]),
		"audio": data[7],
		"volume": float(data[8]),
		"next": data[9].replace("[", "").replace("]","").split(",")
	}
