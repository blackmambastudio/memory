extends Button


func _on_Language_mouse_entered():
	$Hover.playsound()


func _on_Language_button_down():
	$Click.playsound()
