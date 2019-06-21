extends Sprite

func _ready():
	for area in $Clickeables.get_children():
		area.connect('clicked', self, '_on_clicked')

func _on_clicked(clickeable_name):
	print(clickeable_name)
