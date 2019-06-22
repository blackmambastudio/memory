extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Login/Password.set_text("")
	for key in $Login/Keys.get_children():
		key.connect("button_up", self, "key_pressed", [key.name])

func key_pressed(letter):
	$Login/Password.text += letter
	if $Login/Password.text.length() == 6:
		# TODO: Check if the password matches Nick's password
		if $Login/Password.text == "MACHIN":
			for key in $Login/Keys.get_children():
				key.set_disabled(true)
			$AnimationPlayer.play("Login")
			yield($AnimationPlayer, "animation_finished")
			$Login.hide()
			$AnimationPlayer.play("Desktop")
	elif $Login/Password.text.length() > 6:
		$Login/Password.set_text("")
