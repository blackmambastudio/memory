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
		"Dialogue/next":
			self.Dialogue.solve_next()
		"Dialogue/stack":
			self.Dialogue.add_dialogue_graph(request.path)
		_:
			return false
	
#warning-ignore:unreachable_code
	return true