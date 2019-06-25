extends Control

signal item_selected
var clipped_to_left = false


func _ready():
	for element in $Elements.get_children():
		element.connect("item_selected", self, "selected_item")

func selected_item(item):
	$SFX_Select.playsound()
	emit_signal("item_selected", item)

func createMemory(memory_name):
	for element in $Elements.get_children():
		element.create_memory(memory_name)

func destroyMemory(memory_name):
	for element in $Elements.get_children():
		element.destroy_memory(memory_name)

func enableOnly(memories):
	for element in $Elements.get_children():
		element.enable_if_is(memories)

func disableAll():
	for element in $Elements.get_children():
		element.disable()

func enableReal():
	for element in $Elements.get_children():
		element.enable(true)

# should hide elements on the left
func clip_left():
	$Elements/WindowLeft.visible = false
	$Elements/Phone.visible = false
	$Elements/Newspaper.visible = false
	$Elements/Poster.visible = false
	self.rect_size.x = 1280/2
	for child in get_children():
		if child.get("position"):
			child.position.x -=1280/2
		elif child.get("rect_position"):
			child.rect_position.x -=1280/2
	self.rect_position.x = 1280/2
	clipped_to_left = true
	

func clip_restore():
	self.rect_size.x = 1280
	$Elements/WindowLeft.visible = true
	$Elements/Phone.visible = true
	$Elements/Newspaper.visible = true
	$Elements/Poster.visible = true
	$Elements/WindowRight.visible = true
	$Elements/DoorTag.visible = true
	$Elements/Cockroach.visible = true
	$Elements/RoomKey.visible = true
	$Elements/Tv.visible = true
	$Elements/Papelito.visible = true
	$Elements/Luggage.visible = true
	if clipped_to_left:
		self.rect_size.x = 1280/2
		for child in get_children():
			if child.get("position"):
				child.position.x +=1280/2
			elif child.get("rect_position"):
				child.rect_position.x +=1280/2
		self.rect_position.x = 0
		clipped_to_left = false

# should hide elements on the right
func clip_right():
	self.rect_size.x = 1280/2
	$Elements/WindowRight.visible = false
	$Elements/DoorTag.visible = false
	$Elements/Cockroach.visible = false
	$Elements/RoomKey.visible = false
	$Elements/Tv.visible = false
	$Elements/Papelito.visible = false
	$Elements/Luggage.visible = false

