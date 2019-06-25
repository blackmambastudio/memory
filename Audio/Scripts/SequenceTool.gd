extends "res://Audio/Scripts/SoundObject.gd"

var index_sound = 0
var select_sound
var canplay
var soundList


func _ready():
	soundList = get_child_count()
#	

func playsound():
	
	
	select_sound = get_child(index_sound)
	select_sound.set_bus(Bus) 
	var avVolume = select_sound.Volume + Volume
	var avPitch = select_sound.Pitch + Pitch 
	index_sound = index_sound + 1
	if index_sound == soundList:
		index_sound = 0
	
	if RandomVolume == true:
		select_sound.randomizeVol(avVolume, minVolume, maxVolume)
	else:
		select_sound.set_volume_db(avVolume)
	
	
	if RandomPitch == true:
		select_sound.randomizePitch(avPitch, minPitch, maxPitch)
	#	select_sound.set_pitch_scale((Pitch) + ranPitch)
	else:
		select_sound.set_pitch_scale(avPitch+1)
	select_sound.playsound()
