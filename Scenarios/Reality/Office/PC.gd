extends Node2D

onready var ActionRouter = get_node("/root/ActionRouter")
var password = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_password()

	# Connect signals
	for key in $Login/Keys.get_children():
		key.connect("button_up", self, "key_pressed", [key.name])
	$Desktop/NrgSys.connect("button_up", self, "open_nrg_app")
	$Desktop/Reports.connect("button_up", self, "open_reports_folder")
	$"Desktop/EnergyApp/4A".connect("button_up", self, "click_default_sector")
	$"Desktop/EnergyApp/4B".connect("button_up", self, "click_default_sector")
	$"Desktop/EnergyApp/4C".connect("button_up", self, "click_target")
	$Desktop/FileManager/Close.connect("button_up", self, "close_fileman")
	$Desktop/FileManager/TulemaFile.connect("button_up", self, "click_default_report")
	$Desktop/FileManager/SutanoFile.connect("button_up", self, "click_default_report")
	$Desktop/FileManager/MelanoFile.connect("button_up", self, "click_target_report")
	$Desktop/CeciliaReport/Close.connect("button_up", self, "close_report")
	
	# Check if the player should have access to the Reports
	if VariableBoard.get_value("remember_times") < 3:
		$Desktop/Reports.hide()
	
	ActionRouter.request({
	    "action": "Game/Wordsearch/visible",
		"visible": true
	})
	

func clear_password():
	password = ""
	for field in $Login/Password.get_children():
		field.set_text("")

func key_pressed(letter):
	if letter == "Delete":
		$SFX_Erase.playsound()
		if password.length() > 0:
			$Login/Password.get_child(password.length() - 1).set_text("")
			password.erase(password.length() - 1, 1)
		return
	else:
		$SFX_Input.playsound()

	password += letter
	$Login/Alert.hide()

	$Login/Password.get_child(password.length() - 1).set_text(letter)
	if password.length() == 6:
		# TODO: Check if the password matches Nick's password
		if password == "DEIANA":
			for key in $Login/Keys.get_children():
				key.set_disabled(true)
			$Desktop.show()
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Login")
			$Login/SFX_Login.playsound()
			yield($AnimationPlayer, "animation_finished")
			$Login.hide()
			$AnimationPlayer.play("Desktop")
			ActionRouter.request({
			    "action": "Game/Wordsearch/visible",
				"visible": false
			})
		else:
			clear_password()
			$SFX_Alert.playsound()
			$Login/Alert.show()

func open_nrg_app():
	$AnimationPlayer.play("OpenApp")
	$Desktop/SFX_Open.playsound()
	$Desktop/SFX_Energy.playsound()
	yield($AnimationPlayer, "animation_finished")
	for sector in $Desktop/EnergyApp.get_children():
		sector.show()

func open_reports_folder():
	$Desktop/FileManager.show()
	$Desktop/SFX_Open.playsound()
	$Desktop/SFX_Docs.playsound()
	$AnimationPlayer.play("OpenFileMan")
	yield($AnimationPlayer, "animation_finished")
	for button in $Desktop/FileManager.get_children():
		button.set_disabled(false)
	
func click_default_sector():
	VariableBoard.set_value("clicked", "wrong_sector")
	ActionRouter.request({
	    "action": "Dialogue/stack",
		"path": "res://Levels/act4/thoughts.data"
	})

func click_target():
	$Desktop/SFX_EnergySelect.playsound()
	VariableBoard.set_value("clicked", "escape_sector")
	ActionRouter.request({
	    "action": "Dialogue/stack",
		"path": "res://Levels/act4/thoughts.data"
	})

func close_fileman():
	$Desktop/SFX_Close.playsound()
	for button in $Desktop/FileManager.get_children():
		button.set_disabled(true)
	$Desktop/FileManager.hide()
	$AnimationPlayer.get_animation("OpenFileMan").clear()

func click_default_report():
	VariableBoard.set_value("clicked", "wrong_report")
	ActionRouter.request({
	    "action": "Dialogue/stack",
		"path": "res://Levels/act4/thoughts.data"
	})

func click_target_report():
	$Desktop/SFX_Open.playsound()
	$Desktop/CeciliaReport.show()
	$Desktop/SFX_DocsOp.playsound()
	$AnimationPlayer.play("OpenReport")
	VariableBoard.set_value("clicked", "cecilia_report")
	VariableBoard.set_value("end_code", "escape")
	ActionRouter.request({
	    "action": "Dialogue/stack",
		"path": "res://Levels/act4/thoughts.data"
	})

func close_report():
	$Desktop/SFX_Close.playsound()
	$Desktop/CeciliaReport.hide()