extends "res://Acts/ViewScene.gd"


func _on_clicked(clickeable_name):
	if clickeable_name == 'Left_action':
		print("do left")
	elif clickeable_name == 'Middle_action':
		print("do middle")
	elif clickeable_name == 'Right_action':
		print("do action")
