class_name Dialogue
const DialogueParser = preload("DialogueParser.gd")

signal finish

# represents the conversational graph
var graph = {}
var current_block_id
var status = 'NONE'
var ActionRouter
var VariableBoard

func _init(file):
	self.graph = DialogueParser.parse_dialogue(file)

func set_action_router(actionRouter):
	self.ActionRouter = actionRouter

func set_variable_board(VariableBoard):
	self.VariableBoard = VariableBoard

func get_root():
	var nodes = self.graph.keys()
	for key in self.graph.keys():
		var node = self.graph[key]
		for n in node.next:
			nodes.erase(n.strip_edges())
	return nodes[0]


func start():
	ActionRouter.request({
		"action":"Dialogue/display",
		"text_id": self.get_root()
	})

func get_text_object(text_id):
	return self.graph[text_id.strip_edges()]


func _on_item_selected(item):
	if self.status == 'WAITING_INPUT':
		var block = self.get_text_object(self.current_block_id)
		var default = ''
		for next in block.next:
			var item_candidate = self.get_text_object(next)
			if item_candidate.option.to_lower() == item.to_lower():
				default = next
				break
			if item_candidate.option.to_lower() == 'other':
				default = next
		
		if not default.empty():
			self.set_current_block(default)
			self.solve()


func resume():
	self.status = 'NONE'
	self.solve()
	pass

func solve():
	var block = self.get_text_object(self.current_block_id)
	var next_blocks = get_next_blocks(block)
	if len(next_blocks) == 0:
		# should emit a dialogue finished
		emit_signal('finish')
		return

	var candidate = get_text_object(next_blocks[0])

	if candidate.type == 'dialog':
		randomize()
		var next = next_blocks[randi() % next_blocks.size()]
		ActionRouter.request({
			"action":"Dialogue/display",
			"text_id": next
		})
		self.status = 'DISPLAY'

	if candidate.type == 'option':
		self.status = 'WAITING_INPUT'
	
	if candidate.type == 'embedded':
		ActionRouter.request({
			"action":"Dialogue/stack",
			"path": candidate.file
		})
		self.status = 'PAUSED'
		self.set_current_block(next_blocks[0])

	if candidate.type == "filter":
		var next_id = ''
		for next in next_blocks:
			var filter = self.get_text_object(next)
			var variable_value = self.VariableBoard.get_value(filter.variable)
			
			# implicit default the first filter on list
			if next_id.empty():
				next_id = next
			
			# explicit default, the condition default is present on item
			if filter.condition == 'default':
				next_id = next

			# variable is not registered, couldn't match any condition
			if variable_value == null:
				print("variable ", filter.variable, " is not defined")
				continue
			
			if filter.condition == 'equals' and str(variable_value) == filter.value:
				next_id = next
				break

			if filter.condition == 'greater' and variable_value > float(filter.value):
				next_id = next
				break
			if filter.condition == 'less' and variable_value < float(filter.value):
				next_id = next
				break

		self.set_current_block(next_id)
		self.solve()


func set_current_block(text_id):
	self.current_block_id = text_id


func get_next_blocks(block_object):
	var candidates = block_object.next
	if candidates[0].empty():
		return []
	return candidates