extends Node

var Dialogue

func set_dialogue(Dialogue):
	self.Dialogue = Dialogue

func handle(request):
	match request.action:
		"Dialogue/display":
			self.Dialogue.set_text(request.text_id)
		"Dialogue/clear":
			self.Dialogue.cls()
		"Dialogue/end":
			self.Dialogue.solve(request.text_id)
		_:
			return false
	
#warning-ignore:unreachable_code
	return true