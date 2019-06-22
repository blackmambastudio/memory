extends "res://Acts/ViewScene.gd"
onready var VariableBoard = get_node("/root/VariableBoard")


func _on_clicked(clickeable_name):
	if clickeable_name == 'pills':
		print("say something about the pills")
	elif clickeable_name == 'sopa':
		set_soup_visible(true)
	elif clickeable_name == 'ExitSoup':
		set_soup_visible(false)
	elif clickeable_name == 'Cajon':
		self.open_box()
	elif clickeable_name == 'Control':
		VariableBoard.set_value("inv_control", true)
		self.close_box()


func set_soup_visible(visible):
	$SopaLetras.visible = visible
	$Clickeables/ExitSoup.visible = visible
	$ChangeZones.visible = not visible

func open_box():
	if not VariableBoard.get_value("inv_key"):
		return
	else:
		self.toggle_background("Box_opened")
		$Clickeables/Cajon.visible = false
		$Clickeables/Control.visible = true

func close_box():
	self.toggle_background("Box_opened")
	$Clickeables/Cajon.visible = false
	$Clickeables/Control.visible = false