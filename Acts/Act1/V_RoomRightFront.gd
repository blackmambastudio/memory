extends "res://Acts/ViewScene.gd"



func _on_clicked(clickeable_name):
	if clickeable_name == 'pills':
		print("say something about the pills")
	elif clickeable_name == 'sopa':
		set_soup_visible(true)
	elif clickeable_name == 'ExitSoup':
		set_soup_visible(false)
	elif clickeable_name == 'Cajon':
		self.toggle_background("Box_opened")


func set_soup_visible(visible):
	$SopaLetras.visible = visible
	$Clickeables/ExitSoup.visible = visible
	$ChangeZones.visible = not visible
