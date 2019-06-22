extends Control

signal item_selected

func _ready():
	for element in $Elements.get_children():
		element.connect("item_selected", self, "selected_item")

func selected_item(item):
	emit_signal("item_selected", item)

func createMemory(memory_name):
	for element in $Elements.get_children():
		element.create_memory(memory_name)

func destroyMemory(memory_name):
	for element in $Elements.get_children():
		element.destroy_memory(memory_name)