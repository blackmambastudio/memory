extends Node

var ActManager

func set_act_manager(ActManager):
	self.ActManager = ActManager

func handle(request):
	match request.action:
		"Act/Views/change":
			self.ActManager.change_view(request.view)
		"Act/show":
			self.ActManager.load_act(request.act)
		"Act/end":
			self.ActManager.finish_act(request.next)
		"Act/Views/setBackground":
			self.ActManager.change_view_background(request.background)
		_:
			return false
	
#warning-ignore:unreachable_code
	return true