tool
extends GraphNode

export (String) var en_text = 'english dialogue'
export (String) var es_text = 'dialogo en español'
export (int) var option_selected = -1

func _ready():
	connect("close_request", self, "_on_control_close_request")
	connect("resize_request", self, "_on_resize_request")
	set_slot(0, true, 0, Color(1,1,1,1), true, 0, Color(0,1,1,1))
	$dialog_en.text = self.en_text
	$dialog_es.text = self.es_text
	$dialog_en.connect("text_changed", self, "_on_update_text")
	$dialog_es.connect("text_changed", self, "_on_update_text")
	$OptionButton.add_item("peluca", 0)
	$OptionButton.add_item("fotografia", 1)
	$OptionButton.add_item("traje", 2)
	$OptionButton.select(self.option_selected)
	$OptionButton.connect("item_selected", self, "_on_set_option")

func _on_control_close_request():
	queue_free()

func _on_resize_request(new_minsize):
	rect_size = new_minsize

func _on_update_text():
	self.es_text = $dialog_es.text
	self.en_text = $dialog_en.text

func _on_set_option(id):
	self.option_selected = id
