extends "res://Scenarios/Reality/DinerRoom/WindowLayer.gd"

var is_playing = false


func _process(delta):
	if visible:
		toggle_on()
	else:
		toggle_off()

func toggle_on():
	if not is_playing:
		playsound()
		is_playing = true
		
func toggle_off():
	if is_playing:
		stopsound()
		is_playing = false
