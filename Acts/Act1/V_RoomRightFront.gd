extends "res://Acts/ViewScene.gd"
onready var VariableBoard = get_node("/root/VariableBoard")

func _ready():
	$SopaLetras.connect("word_match", self, "word_found")
	
func word_found(word):
	if word == 'remember':
		print("displays a flash!!")

func _on_clicked(clickeable_name):
	if clickeable_name == 'pills':
		$Clickeables/pills/SFX_Pills.playsound()
		VariableBoard.set_value("clicked", clickeable_name)
		ActionRouter.request({
		    "action": "Dialogue/stack", "path": "res://Levels/act1/thoughts.data"
		})
	elif clickeable_name == 'sopa':
		set_soup_visible(true)
		$SopaLetras/SFX_Sopa_OC.playsound()
	elif clickeable_name == 'ExitSoup':
		set_soup_visible(false)
		$SopaLetras/SFX_Sopa_OC.playsound()
	elif clickeable_name == 'Cajon':
		self.open_box()
	elif clickeable_name == 'Control':
		VariableBoard.set_value("inv_control", true)
		self.close_box()

func _on_looked(clickeable_name):
	VariableBoard.set_value("looked", clickeable_name)
	ActionRouter.request({
	    "action": "Dialogue/stack", "path": "res://Levels/act1/thoughts.data"
	})

func _on_exit():
	ActionRouter.request({"action": "Dialogue/clear"})
	VariableBoard.set_value("looked", "")
	VariableBoard.set_value("clicked", "")

func set_soup_visible(visible):
	$SopaLetras.visible = visible
	$Clickeables/ExitSoup.visible = visible
	$ChangeZones.visible = not visible

func open_box():
	if not VariableBoard.get_value("inv_key"):
		$Clickeables/Cajon/SFX_Locked.playsound()
		VariableBoard.set_value("clicked", "Cajon")
		ActionRouter.request({
		    "action": "Dialogue/stack", "path": "res://Levels/act1/thoughts.data"
		})
		return
	else:
		self.toggle_background("Box_opened")
		$Clickeables/Cajon/SFX_OC.playsound()
		$Clickeables/Cajon.visible = false
		$Clickeables/Control.visible = true

func close_box():
	self.toggle_background("Box_opened")
	$Clickeables/Cajon/SFX_OC.playsound()
	$Clickeables/Cajon.visible = false
	$Clickeables/Control.visible = false