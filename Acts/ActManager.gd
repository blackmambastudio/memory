extends Control
onready var ActionRouter = get_node("/root/ActionRouter")

const ActActions = preload("act_actions.gd")
onready var actionHandler = ActActions.new()

var current_act
func _ready():
	self.actionHandler.set_act_manager(self)
	ActionRouter.register_actions(self.actionHandler)
	
	self.load_act("res://Acts/Act3/Act3_Kitchen.tscn")

func load_act(act_name):
	if current_act:
		current_act.queue_free()
	var new_act = load(act_name).instance()
	current_act = new_act
	add_child(current_act)
	current_act.start()

func change_view(view_name):
	current_act.change_view(view_name)

func change_view_background(background):
	current_act.change_view_background(background)