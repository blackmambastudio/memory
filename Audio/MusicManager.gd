extends Control

onready var tween_out = get_node("Fade")

export (AudioStream) var Payaso1
export (AudioStream) var Payaso2
export (AudioStream) var Guaricha1
export (AudioStream) var Guaricha2
export (bool) var real = true
export (String) var current_memory = ""

export var fadein_duration = 4
export var fadeout_duration = 4
export var transition_type = 1 


var pending_change = false
var is_playing = false
var next_stream_level
var active_voice
var fadingout


func _ready():
	active_voice = $MX_Voice_1
	current_memory = "Payaso"

func _music_start():
	is_playing = true
	set_mx()
	active_voice.playsound()
	

func set_mx():
	if real:
		$MX_Voice_1.set_stream(Payaso1)
		$MX_Voice_2.set_stream(Payaso1)
		next_stream_level = Payaso2
	else: 
		$MX_Voice_1.set_stream(Guaricha1)
		$MX_Voice_2.set_stream(Guaricha1)
		next_stream_level = Guaricha2
	
#	if real and current_memory == "Ventana_Platanal":
#		$MX_Voice_1.set_stream(Payaso1)
#		$MX_Voice_2.set_stream(Payaso1)
#		next_stream_level = Payaso2
#	else: 
#		$MX_Voice_1.set_stream(Guaricha1)
#		$MX_Voice_2.set_stream(Guaricha1)
#		next_stream_level = Guaricha2
#
#	if real and current_memory == "Ventana_Hunuragha":
#		$MX_Voice_1.set_stream(Payaso1)
#		$MX_Voice_2.set_stream(Payaso1)
#		next_stream_level = Payaso2
#	else: 
#		$MX_Voice_1.set_stream(Guaricha1)
#		$MX_Voice_2.set_stream(Guaricha1)
#		next_stream_level = Guaricha2

func change_mx():
	
	Payaso1.set_loop(false) 
	Guaricha1.set_loop(false) 
	
	if not $MX_Voice_1.is_playing():
		$MX_Voice_1.set_stream(next_stream_level)
		print('soy el 1 y cambie')
	if not $MX_Voice_2.is_playing():
		$MX_Voice_2.set_stream(next_stream_level)
		print('soy el 2 y cambie')

func _on_MX_Voice_finished():
	$MX_Voice_2.playsound()
	active_voice = $MX_Voice_2


func _on_MX_Voice_2_finished():
	$MX_Voice_1.playsound()
	active_voice = $MX_Voice_1


func fade_in():
	fadingout = false
	tween_out.interpolate_property(active_voice, "volume_db", -80, 0, fadein_duration, transition_type, Tween.EASE_OUT, 1)
	tween_out.start()

func fade_out():
	fadingout = true
	if is_playing:
		tween_out.interpolate_property(active_voice, "volume_db", active_voice.volume_db, -80, fadeout_duration, transition_type, Tween.EASE_OUT, 1)
		tween_out.start()
	


func _on_Fade_tween_completed(object, key):
	if fadingout:
		active_voice.stopsound()
		is_playing = false
		
		print ('mori')


func _on_Button_button_down():
	if is_playing == true:
		change_mx()
	else: 
		_music_start()
		fade_in()


func _on_End_button_down():
	fade_out()






