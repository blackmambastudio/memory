extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	OS.set_window_title("Memory | fps: " + str(Engine.get_frames_per_second()))
