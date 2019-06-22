extends Control

export (String) var real_item = ''
export (String) var fictional_item = ''

var Real
var Fictional

func _ready():
	Real = get_node(real_item)
	Fictional = get_node(real_item)
	center_element(Real)
	center_element(Fictional)

	Real.connect("button_down",self,"_on_item_select", [real_item])
	Fictional.connect("button_down",self,"_on_item_select", [fictional_item])

func _on_item_select(item):
	emit_signal("item_selected", item.name)

func center_element(element):
	var centerX = element.rect_size.x/2
	var centerY = element.rect_size.y/2
	element.rect_pivot_offset.x = centerX
	element.rect_pivot_offset.y = centerY
	