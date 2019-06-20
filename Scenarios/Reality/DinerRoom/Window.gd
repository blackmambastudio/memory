extends Node2D

var index_BG = 0
var index_Main = 0
onready var items = [$mountains, $mountain_2, $stars, $moon, $clouds, $birds, $rain]

func _ready():
	pass # Replace with function body.


func bg_to_left():
	$BG.get_child(index_BG).visible = false
	index_BG -= 1
	if index_BG < 0:
		index_BG = 3
	
	$BG.get_child(index_BG).visible = true


func bg_to_right():
	$BG.get_child(index_BG).visible = false
	index_BG += 1
	if index_BG > 3:
		index_BG = 0
	$BG.get_child(index_BG).visible = true


func main_to_left():
	$Main.get_child(index_Main).visible = false
	index_Main -= 1
	if index_Main < 0:
		index_Main = 3
	
	$Main.get_child(index_Main).visible = true

func main_to_right():
	$Main.get_child(index_Main).visible = false
	index_Main += 1
	if index_Main > 3:
		index_Main = 0
	$Main.get_child(index_Main).visible = true

func toggle_item(index):
	items[index].visible = not items[index].visible

