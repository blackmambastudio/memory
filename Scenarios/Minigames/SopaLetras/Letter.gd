tool
extends Control

export (String) var key
var index = -1
signal on_click
signal hovered

var selected = false

func _ready():
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_exit")
	connect("gui_input", self, "_on_input")

func set_letter(index, letter):
	$Key.text = letter
	self.index = index
	
func set_text(letter):
	$Key.text = letter

func _on_hover():
	if selected: return
	$Back.color = Color(0.2,0.2,0.2,1)
	emit_signal("hovered", self)

func _on_exit():
	if selected: return
	$Back.color = Color("f4f2e5")

func _on_input(Event):
	if Event is InputEventMouseButton and !Event.pressed:
		emit_signal("on_click", index)

func select():
	selected = true

func unselect():
	selected = false
	$Back.color = Color("f4f2e5")
	
func set_matched():
	$Key.modulate = Color(0.7,0.2,0.2)

func unmatched():
	$Key.modulate = Color("444470")
