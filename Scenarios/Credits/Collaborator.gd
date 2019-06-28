tool
extends Control

export (Texture) var icon
export (String) var character = ''
export (String) var actor = ''
export (String) var nickname = ''
export (bool) var voice = false
export (bool) var left_side = true


func _ready():
	$VoiceActing.visible = voice
	$texture.texture = icon
	$texture2.texture = icon
	$Credit/Character.text = character
	$Credit/Actor.text = actor
	$Credit/arroba.text = nickname
	
	if not left_side:
		$Credit.rect_position.x = 50
		$texture.position.x = 660
		$texture2.position.x = 660
		$texture.rotation *= -1
		$texture2.rotation *= -1
