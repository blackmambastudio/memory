extends Node

onready var tween_out = get_node("Fade")
onready var MX = get_node("MX_Menu")

export var transition_duration = 4
export var transition_type = 1 # TRANS_SINE

func _ready():
	MX.play()
	
	#fade_in(MX)

func fade_in():
	tween_out.interpolate_property(MX, "volume_db", MX.volume_db, 0, transition_duration, transition_type, Tween.EASE_OUT, 1)
	tween_out.start()

func fade_out():
	tween_out.interpolate_property(MX, "volume_db", MX.volume_db, -80, transition_duration, transition_type, Tween.EASE_OUT, 1)
	tween_out.start()
