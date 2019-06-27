extends Control

export(String, "Act1/Act1_Room", "Act2/Act2_Room1", "Act2/Act2_Test", "Act2/Act2_Room2", "Act3/Act3_Room1", "Act3/Act3_Test", "Act3/Act3_Kitchen", "Act4/Act4_Room", "Act4/Act4_Test", "Act4/Act4_Office", "Act4/Act4_Hall", "Act5/Act5") var first_act = "Act1/Act1_Room"

const ActActions = preload("act_actions.gd")

var current_act
var fade_out_on_load = false

onready var actionHandler = ActActions.new()
onready var ActionRouter = get_node("/root/ActionRouter")

func _ready():
	self.actionHandler.set_act_manager(self)
	ActionRouter.register_actions(self.actionHandler)
	
	# Create variables for handling the actos
	ActionRouter.request({
		"action":"Board/register", "variable":"current_act_id", "value": ""
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"lucia_patience", "value": 0
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"lucia_sleepiness", "value": 0
	})

	# Create variables for handling the inventario
	ActionRouter.request({
		"action":"Board/register", "variable":"took_pills", "value": false
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"inv_key", "value": false
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"inv_control", "value": false
	})
	
	# Create variables for handling the personajes
	ActionRouter.request({
		"action":"Board/register", "variable":"view_monitor_status", "value": "0"
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"view_claire_status", "value": "0"
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"view_hands_status", "value": "0"
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"view_lucia_status", "value": "0"
	})
	
	# Create variables for handling the pruebas
	ActionRouter.request({
		"action":"Board/register", "variable":"test_split_memory", "value": 0
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"view_active_minigame", "value": 'auto'
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"start_active_minigame", "value": false
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"finish_test", "value": false
	})
	ActionRouter.request({
		"action":"Board/register", "variable":"leave_test", "value": false
	})
	
	#self.load_act(all_acts[0])

func load_act(act_name = null):
	if not act_name and first_act:
		act_name = "res://Acts/" + first_act + ".tscn"
	if current_act:
		current_act.queue_free()
	var new_act = load(act_name).instance()
	current_act = new_act
	ActionRouter.request({
		"action":"Board/set_value",
		"variable":"current_act_id",
		"value": act_name.split("/", false)[2].to_lower()
	})
	add_child(current_act)
	current_act.start()
	if not current_act.starting_dialogue.empty():
		ActionRouter.request({
			"action": "Dialogue/stack",
			"path": current_act.starting_dialogue
		})
		yield(get_tree().create_timer(1.0), "timeout")
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