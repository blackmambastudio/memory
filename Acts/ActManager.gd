extends Control
onready var ActionRouter = get_node("/root/ActionRouter")

const ActActions = preload("act_actions.gd")
onready var actionHandler = ActActions.new()

var current_act
var all_acts = [
	"res://Acts/Act1/Act1_Room.tscn",
	
	"res://Acts/Act2/Act2_Room1.tscn",
	"res://Acts/Act2/Act2_Test.tscn",
	"res://Acts/Act2/Act2_Room2.tscn",
	
	"res://Acts/Act3/Act3_Room1.tscn",
	"res://Acts/Act3/Act3_Test.tscn",
	"res://Acts/Act3/Act3_Kitchen.tscn",
	
	"res://Acts/Act4/Act4_Room.tscn",
	"res://Acts/Act4/Act4_Test.tscn",
	"res://Acts/Act4/Act4_Office.tscn",
	"res://Acts/Act4/Act4_Hall.tscn"
]
var fade_out_on_load = false

func _ready():
	self.actionHandler.set_act_manager(self)
	ActionRouter.register_actions(self.actionHandler)
	
	ActionRouter.request({"action":"Board/register", "variable":"inv_key", "value": false})
	ActionRouter.request({"action":"Board/register", "variable":"inv_control", "value": false})
	
	ActionRouter.request({"action":"Board/register", "variable":"view_monitor_status", "value": "0"})
	ActionRouter.request({"action":"Board/register", "variable":"view_claire_status", "value": "0"})
	ActionRouter.request({"action":"Board/register", "variable":"view_hands_status", "value": "0"})
	
	ActionRouter.request({"action":"Board/register", "variable":"test_split_memory", "value": 0})
	# valid values: auto and reflexes
	ActionRouter.request({"action":"Board/register", "variable":"view_active_minigame", "value": 'auto'})
	
	#self.load_act(all_acts[0])

func load_act(act_name):
	if current_act:
		current_act.queue_free()
	var new_act = load(act_name).instance()
	current_act = new_act
	add_child(current_act)
	current_act.start()
	if not current_act.starting_dialogue.empty():
		ActionRouter.request({"action": "Dialogue/stack", "path": current_act.starting_dialogue})
		yield(get_tree().create_timer(1.5), "timeout")
		ActionRouter.request({"action": "Game/ToNormal"})

func change_view(view_name):
	current_act.change_view(view_name)

func change_view_background(background):
	current_act.change_view_background(background)

func finish_act(next):
	ActionRouter.request({"action": "Game/ToBlack"})
	yield(get_tree().create_timer(2.0), "timeout")
	fade_out_on_load = true
	load_act(next)