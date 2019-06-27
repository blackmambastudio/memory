extends Control

export (AudioStream) var Payaso1
export (AudioStream) var Payaso2
export (AudioStream) var Guaricha1
export (AudioStream) var Guaricha2

var pending_change = false
var is_playing = false
var real = false
var unreal = false
var next_stream_level

func _music_start():
	$MX_Voice_1.playsound()
	is_playing = true
	set_mx()

func set_mx():
	if real:
		$MX_Voice_1.set_stream(Payaso1)
		$MX_Voice_2.set_stream(Payaso1)
		next_stream_level = Payaso2
	if unreal: 
		$MX_Voice_1.set_stream(Guaricha1)
		$MX_Voice_2.set_stream(Guaricha1)
		next_stream_level = Guaricha2

func change_mx():
	
	if not $MX_Voice_1.is_playing():
		$MX_Voice_1.set_stream(next_stream_level)
		print('soy el 1 y cambie')
	if not $MX_Voice_2.is_playing():
		$MX_Voice_2.set_stream(next_stream_level)
		print('soy el 2 y cambie')

func _on_MX_Voice_finished():
	$MX_Voice_2.playsound()


func _on_MX_Voice_2_finished():
	$MX_Voice_1.playsound()



func _on_Button_button_down():
	
	if is_playing == true:
		change_mx()
	else: 
		_music_start()
