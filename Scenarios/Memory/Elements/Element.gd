extends Control

export (String) var real_item = ''
export (String) var fictional_item = ''

signal item_selected

var Real
var Fictional

var real_factor = 1.0
var fictional_factor = 0.0
var inception = false


func _ready():

	if not real_item.empty():
		Real = get_node(real_item)
		Real.connect("button_down",self,"_on_item_select", [real_item])
		center_element(Real)
	if not fictional_item.empty():
		Fictional = get_node(fictional_item)
		Fictional.connect("button_down",self,"_on_item_select", [fictional_item])
		center_element(Fictional)

func _on_item_select(item):
	emit_signal("item_selected", item)
	if item == fictional_item and not self.inception:
		reforce_fictional()

func center_element(element):
	var centerX = element.rect_size.x/2
	var centerY = element.rect_size.y/2
	element.rect_pivot_offset.x = centerX
	element.rect_pivot_offset.y = centerY

func create_memory(memory):
	if fictional_item.empty(): return
	if memory != fictional_item: return
	fictional_factor = 0.2
	real_factor = 0.6
	Fictional.show()
	reforce_fictional()

func destroy_memory(memory):
	if memory != real_item: return
	Real.hide()

func reforce_fictional():
	if fictional_item.empty(): return
	fictional_factor += 0.1
	real_factor -= 0.1
	Fictional.modulate = Color(1.0,1.0,1.0, fictional_factor + 0.3)
	Real.modulate = Color(1.0,1.0,1.0, real_factor + 0.2)
	if fictional_factor >= 0.5:
		Real.hide()
		inception = true
