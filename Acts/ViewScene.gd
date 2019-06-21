extends Sprite

func _ready():
	for area in $Clickeables.get_children():
		area.connect('clicked', self, '_on_clicked')

func _on_clicked(clickeable_name):
	print(clickeable_name)

func set_background(background):
	for child in $Backgrounds.get_children():
		child.visible = child.name == background

func toggle_background(background):
	var bg = $Backgrounds.get_node(background)
	if bg:
		bg.visible = not bg.visible
