extends Control

signal item_selected

func _ready():
	for element in $Elements.get_children():
		element.connect("button_down",self,"_on_item_select", [element])

func _on_item_select(item):
	emit_signal("item_selected", item.name)