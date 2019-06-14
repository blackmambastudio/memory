extends Control
onready var ActionRouter = get_node("/root/ActionRouter")

const DialogueActions = preload("dialogue_actions.gd")
onready var actionHandler = DialogueActions.new()
var _on_timeout_action = {}

func _ready():
	self.actionHandler.set_dialogue(self)
	ActionRouter.register_actions(self.actionHandler)
	$Timer.connect("timeout", self, "timeout")

func set_text(text_id):
	var text_object = self.get_text_object(text_id)
	$Panel/Text.text = text_object.text
	$Timer.set_wait_time(text_object.timeout)
	$Timer.start()
	_on_timeout_action = text_object.on_timeout


func _on_item_selected(item):
	if not $Timer.is_stopped(): return
	ActionRouter.request({
		"action":"Dialogue/display",
		"text_id": item
	})


func get_text_object(text_id):
	return {
		"Peluca": {
			"text": "Mi peluca favorita",
			"timeout": 2,
			"on_timeout": {
				"action": "Dialogue/display",
				"text_id": "dialogue#33"
			}
		},
		"ID": {
			"text": "Mi Nombre es Cecilia Melano",
			"timeout": 2,
			"on_timeout": {
				"action": "Dialogue/display",
				"text_id": "dialogue#33"
			}
		},
		"Costume": {
			"text": "Era la mejor payaso",
			"timeout": 2,
			"on_timeout": {
				"action": "Dialogue/display",
				"text_id": "dialogue#33"
			}
		},
		"dialogue#33": {
			"text": "...",
			"timeout": 1,
			"on_timeout": {
				"action": "Dialogue/clear"
			}
		}
	}[text_id]


func timeout():
	ActionRouter.request(_on_timeout_action)

func cls():
	$Panel/Text.text = ""