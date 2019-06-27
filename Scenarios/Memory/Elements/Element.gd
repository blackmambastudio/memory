extends Control

export (String) var real_item = ''
export (String) var fictional_item = ''
enum NamedEnum {ONE, TWO}
export (NamedEnum) var needed_attempts = NamedEnum.TWO

signal item_selected
signal memory_replaced

var Real
var Fictional

var real_factor = 1.0
var fictional_factor = 0.0
var inception = false
var time = randi()%1000


onready var VariableBoard = get_node("/root/VariableBoard")


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
	if item == real_item:
		emit_signal("item_selected", real_item)
		return
	if self.inception:
		emit_signal("item_selected", fictional_item)
		return
	if Fictional.modulate.a>Real.modulate.a:
		emit_signal("item_selected", fictional_item)
		reforce_fictional()
	else:
		emit_signal("item_selected", real_item)
		reforce_real()

func center_element(element):
	var centerX = element.rect_size.x/2
	var centerY = element.rect_size.y/2
	element.rect_pivot_offset.x = centerX
	element.rect_pivot_offset.y = centerY

func create_memory(memory):
	if fictional_item.empty(): return
	if memory != fictional_item: return
	if Fictional.is_visible(): return
	fictional_factor = 0.4
	real_factor = 0.7
	Fictional.show()
	reforce_fictional()

func destroy_memory(memory):
	if memory != real_item: return
	Real.hide()

func enable_if_is(memories):
	for memory in memories:
		if memory == real_item:
			Real.show()
		elif memory == fictional_item:
			Fictional.show()

func disable():
	Real.hide()
	if not fictional_item.empty():
		Fictional.hide()

func enable(real):
	if real:
		Real.show()
	else:
		Fictional.show()

func reforce_fictional():
	if fictional_item.empty(): return
	fictional_factor += 0.2
	real_factor -= 0.2
	Fictional.modulate.a = fictional_factor
	Real.modulate.a = real_factor
	if fictional_factor >= (1.0 if needed_attempts == NamedEnum.TWO else 0.8):
		Real.hide()
		inception = true
		VariableBoard.add_value("memories_replaced", 1)

func reforce_real():
	if fictional_item.empty(): return
	fictional_factor -= 0.4
	real_factor += 0.1
	Fictional.modulate.a = fictional_factor
	Real.modulate.a = real_factor
	if real_factor >= (1.0 if needed_attempts == NamedEnum.TWO else 0.6):
		Fictional.hide()
		inception = false
		fictional_factor = 0
		Fictional.modulate.a = fictional_factor
		real_factor = 1.0
		Real.modulate.a = real_factor

func _process(delta):
	time += delta
	if not inception and fictional_factor > 0:
		var factor = (sin(time*1))*0.2
		var alphaness = (factor*2.5)+0.5
		Fictional.rect_position.x -= factor*(1.0-fictional_factor)
		Fictional.rect_position.y -= factor*(1.0-fictional_factor)*0.5
		Real.rect_position.x += factor*(1.0-real_factor)
		Real.rect_position.y -= factor*(1.0-real_factor)*0.5
		Fictional.modulate.a = min(alphaness, fictional_factor)
		Real.modulate.a = real_factor-alphaness
