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

func clear_password():
	password = ""
	for field in $Login/Password.get_children():
		field.set_text("")

func key_pressed(letter):
	if letter == "Delete":
		if password.length() > 0:
			$Login/Password.get_child(password.length() - 1).set_text("")
			password.erase(password.length() - 1, 1)
		return

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
			yield($AnimationPlayer, "animation_finished")
			$Login.hide()
			$AnimationPlayer.play("Desktop")
		else:
			clear_password()
			$Login/Alert.show()

func open_nrg_app():
	$AnimationPlayer.play("OpenApp")
	yield($AnimationPlayer, "animation_finished")
	for sector in $Desktop/EnergyApp.get_children():
		sector.show()

func open_reports_folder():
	$Desktop/FileManager.show()
	$AnimationPlayer.play("OpenFileMan")
	yield($AnimationPlayer, "animation_finished")
	for button in $Desktop/FileManager.get_children():
		button.set_disabled(false)
	
func click_default_sector():
	# TODO: Show a dialog?
	pass

func click_target():
	ActionRouter.request({
		"action":"Act/show", "act": "res://Acts/Act4/Act4_Hall.tscn"
	})

func close_fileman():
	for button in $Desktop/FileManager.get_children():
		button.set_disabled(true)
	$Desktop/FileManager.hide()
	$AnimationPlayer.get_animation("OpenFileMan").clear()

func click_default_report():
	# TODO: Show a dialog
	pass

func click_target_report():
	$Desktop/CeciliaReport.show()
	$AnimationPlayer.play("OpenReport")

func close_report():
	$Desktop/CeciliaReport.hide()