tool
extends GraphNode

export (String) var en_text = 'put your dialogue here'
export (String) var es_text = 'tu dialogo aquí'
export (int) var actor_selected = -1

func _ready():
	connect("close_request", self, "_on_control_close_request")
	connect("resize_request", self, "_on_resize_request")
	set_slot(0, true, 0, Color(1,1,1,1), true, 0, Color(0,1,1,1))
	$dialog_en.text = self.en_text
	$dialog_es.text = self.es_text
	$dialog_en.connect("text_changed", self, "_on_update_text")
	$dialog_es.connect("text_changed", self, "_on_update_text")
	$actor.add_item("Cecilia", 0)
	$actor.add_item("Dr Nick", 1)
	$actor.add_item("Lucia", 2)
	$actor.add_item("Claire", 3)
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
