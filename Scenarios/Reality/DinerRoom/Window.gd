extends Node2D

var index_BG = 0
var index_Main = 0
onready var items = [$mountains, $mountain_2, $stars, $moon, $clouds, $birds, $rain]
onready var VariableBoard = get_node("/root/VariableBoard")

signal mood_match
signal mood_unmatch
var matched = false

var win_configuration = {
	'BG/night_BG': true, 
	'Main/city': true,
	'rain': true
}

func _ready():
	matched = false
	pass # Replace with function body.

func bg_to_left():
	$BG.get_child(index_BG).visible = false
	index_BG -= 1
	if index_BG < 0:
		index_BG = 3
	
	$BG.get_child(index_BG).visible = true
	check_match()

func bg_to_right():
	$BG.get_child(index_BG).visible = false
	index_BG += 1
	if index_BG > 3:
		index_BG = 0
	$BG.get_child(index_BG).visible = true
	check_match()

func main_to_left():
	$Main.get_child(index_Main).visible = false
	index_Main -= 1
	if index_Main < 0:
		index_Main = 3
	
	$Main.get_child(index_Main).visible = true
	check_match()

func main_to_right():
	$Main.get_child(index_Main).visible = false
	index_Main += 1
	if index_Main > 3:
		index_Main = 0
	$Main.get_child(index_Main).visible = true
	check_match()
	
func toggle_item(index):
	items[index].visible = not items[index].visible
	check_match()

func check_match():
	var act = VariableBoard.get_value("current_act_id")
	if act == "act2" and not matched:
		matched = true
		# Trigger the dialog of Cecilia's astonishment.
		VariableBoard.set_value("clicked", "window")
#		ActionRouter.request({
#			"action": "Dialogue/stack",
#			"path": "res://Levels/act2/thoughts.data"
#		})
	elif act == "act3":
		var all_match = true
		for key in win_configuration:
			all_match = all_match and get_node(key).visible
		
		if all_match:
			emit_signal("mood_match")
		elif matched:
			emit_signal("mood_unmatch")
		
		matched = all_match
