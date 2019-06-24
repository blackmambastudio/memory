extends Button


func _on_Start_mouse_entered():
	$Hover.playsound()


func _on_Start_button_down():
	$Click.playsound()
