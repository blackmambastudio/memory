extends Sprite

func _ready():
	for area in $Clickeables.get_children():
		area.connect('clicked', self, '_on_clicked')
		area.connect('looked', self, '_on_looked')
		area.connect('exit', self, '_on_exit')

func _on_clicked(clickeable_name):
	print(clickeable_name)

func _on_looked(clickeable_name):
	print(clickeable_name)

func _on_exit():
	print("exitado")

func set_background(background):
	for child in $Backgrounds.get_children():
		child.visible = child.name == background

func toggle_background(background):
	var bg = $Backgrounds.get_node(background)
	if bg:
		bg.visible = not bg.visible
