extends Node

var routers = []
func _ready():
	pass

# action is a dictionary with a simple structure
# action: 'object/function'
# and more data as needed
func request(action):
	for router in routers:
		var handled = router.handle(action)
		if handled:
			if action.has("pause"):
				yield(router.handle(action), "completed")
			return
	print("no action handler for ", action)

func register_actions(router):
	print("Mmmm: ", router)
	routers.append(router)

