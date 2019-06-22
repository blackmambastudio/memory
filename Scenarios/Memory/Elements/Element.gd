extends Control

export (String) var real_item = ''
export (String) var fictional_item = ''

signal item_selected

var Real
var Fictional


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

func center_element(element):
	var centerX = element.rect_size.x/2
	var centerY = element.rect_size.y/2
	element.rect_pivot_offset.x = centerX
	element.rect_pivot_offset.y = centerY
	