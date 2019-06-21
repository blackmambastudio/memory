extends Node

var ActManager

func set_act_manager(ActManager):
	self.ActManager = ActManager

func handle(request):
	match request.action:
		"Act/Views/change":
			self.ActManager.change_view(request.view)
		"Act/show":
			pass
		"Act/end":
			pass
		_:
			return false
	
#warning-ignore:unreachable_code
	return true