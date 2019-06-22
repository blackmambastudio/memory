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

func add_value(variable, value):
	board[variable] += value
	emit_signal("value_set_" + variable, board[variable])

func get_value(variable):
	if not board.has(variable):
		return null
	return board[variable]

func suscribe(variable, object, method):
	if not board.has(variable): 
		print("variable is not registered")
		return
	self.connect("value_set_"+variable, object, method)
	return board[variable]

func unsuscribe(variable, object, method):
	self.disconnect("value_set_"+variable, object, method)

func handle(request):
	match request.action:
		"Board/register":
			self.register(request.variable, request.value)
		"Board/set_value":
			self.set_value(request.variable, request.value)
		"Board/suscribe":
			self.suscribe(request.variable, request.object, request.method)
		"Board/unsuscribe":
			self.unsuscribe(request.variable, request.object, request.method)
		"Board/further":
			self.add_value(request.variable, 1)
		_:
			return false
	
#warning-ignore:unreachable_code
	return true
