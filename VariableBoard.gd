extends Node

var board = {}

func _ready():
	var ActionRouter = get_node("/root/ActionRouter")
	ActionRouter.register_actions(self)

func register(variable, value):
	if board.has(variable):
		print("variable", variable, "already registered")
		return
	board[variable] = value
	add_user_signal("value_set_" + variable)


func set_value(variable, value):
	board[variable] = value
	emit_signal("value_set_" + variable, value)


func get_value(variable):
	if not board.has(variable):
		return null
	return board[variable]

func handle(request):
	match request.action:
		"Board/register":
			self.register(request.variable, request.value)
		"Board/set_value":
			self.set_value(request.variable, request.value)
		"Board/suscribe":
			self.connect("value_set_"+request.variable, request.object, request.method)
		"Board/unsuscribe":
			self.disconnect("value_set_"+request.variable, request.object, request.method)
		_:
			return false
	
#warning-ignore:unreachable_code
	return true
