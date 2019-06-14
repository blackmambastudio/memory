extends Control


func _ready():
	$Memory/Canvas.connect("item_selected", $DialogueManager, "_on_item_selected")

