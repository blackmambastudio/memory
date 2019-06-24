extends "res://Acts/ViewScene.gd"

func _ready():
	var monitor_status = VariableBoard.suscribe("view_monitor_status", self, "display_monitor")
	var hand_status = VariableBoard.suscribe("view_hands_status", self, "display_hands")
	display_monitor(monitor_status)
	display_hands(hand_status)
	

func display_monitor(display):
	if display:
		$AnimationPlayer.play("show")
	else:
		$AnimationPlayer.play("hide")

func display_hands(value):
	$Backgrounds/RoomFront_hands.visible = value == '1'
	$Backgrounds/RoomFront_hands2.visible = value == '2'

