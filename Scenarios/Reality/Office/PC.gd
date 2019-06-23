extends Node2D

onready var ActionRouter = get_node("/root/ActionRouter")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Login/Password.set_text("")

	# Connect signals
	for key in $Login/Keys.get_children():
		key.connect("button_up", self, "key_pressed", [key.name])
	$Desktop/NrgSys.connect("button_up", self, "open_nrg_app")
	$Desktop/Reports.connect("button_up", self, "open_reports_folder")
	$"Desktop/EnergyApp/4A".connect("button_up", self, "click_default")
	$"Desktop/EnergyApp/4B".connect("button_up", self, "click_default")
	$"Desktop/EnergyApp/4C".connect("button_up", self, "click_target")

func key_pressed(letter):
	$Login/Password.text += letter
	$Login/Alert.hide()
	if $Login/Password.text.length() == 6:
		# TODO: Check if the password matches Nick's password
		if $Login/Password.text == "MACHIN":
			for key in $Login/Keys.get_children():
				key.set_disabled(true)
			$Desktop.show()
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Login")
			yield($AnimationPlayer, "animation_finished")
			$Login.hide()
			$AnimationPlayer.play("Desktop")
	elif $Login/Password.text.length() > 6:
		$Login/Password.set_text("")
		$Login/Alert.show()

func open_nrg_app():
	$AnimationPlayer.play("OpenApp")
	yield($AnimationPlayer, "animation_finished")
	$"Desktop/EnergyApp/4A".show()
	$"Desktop/EnergyApp/4B".show()
	$"Desktop/EnergyApp/4C".show()

func open_reports_folder():
	pass
	
func click_default():
	# TODO: Show a dialog?
	pass

func click_target():
	ActionRouter.request({
		"action":"Act/show", "act": "res://Acts/Act4/Act4_Hall.tscn"
	})