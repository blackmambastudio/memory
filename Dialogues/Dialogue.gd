class_name Dialogue
const DialogueParser = preload("DialogueParser.gd")

# represents the conversational graph
var graph = {}
var current_block
var current_block_id
var status = 'NONE'
var ActionRouter

func _init(file):
	print("new dialogue class created")
	self.graph = DialogueParser.parse_dialogue(file)

func set_action_router(actionRouter):
	self.ActionRouter = actionRouter

func get_root():
	var nodes = self.graph.keys()
	for key in self.graph.keys():
		var node = self.graph[key]
		for n in node.next:
			nodes.erase(n)
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
		for next in block.next:
			var item_candidate = self.get_text_object(next)
			if item_candidate.option.to_lower() == item.to_lower():
				ActionRouter.request({
					"action":"Dialogue/display",
					"text_id": next
				})


func solve():
	var block = self.get_text_object(self.current_block_id)
	var next_blocks = get_next_blocks(block)
	if len(next_blocks) == 0:
		# should emit a dialogue finished
		ActionRouter.request({"action":"Dialogue/cls"})
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



func set_current_block(text_id):
	self.current_block_id = text_id


func get_next_blocks(block_object):
	var candidates = block_object.next
	if candidates[0].empty():
		return []
	return candidates