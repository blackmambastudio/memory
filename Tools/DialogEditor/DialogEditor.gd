extends Control
var DialogNode = load("res://Tools/DialogEditor/DialogNode.tscn")
var OptionNode = load("res://Tools/DialogEditor/OptionElement.tscn")
var EmbeddedNode = load("res://Tools/DialogEditor/EmbeddedDialogue.tscn")
var FilterNode = load("res://Tools/DialogEditor/FilterNode.tscn")
var ActionNode = load("res://Tools/DialogEditor/ActionNode.tscn")

var current_file = ''

var gEditName = 'GraphEdit'
onready var gEdit = get_node(gEditName)

func _ready():
	$CreateConversationNode.connect("button_down", self, "create_node", [DialogNode])
	$CreateOptionNode.connect("button_down", self, "create_node", [OptionNode])
	$CreateEmbeddedNode.connect("button_down", self, "create_node", [EmbeddedNode])
	$CreateFilterNode.connect("button_down", self, "create_node", [FilterNode])
	$CreateActionNode.connect("button_down", self, "create_node", [ActionNode])
	$Save.connect("button_down", self, "check_save")
	$SaveAs.connect("button_down", $SaveDialog, "popup")
	$Load.connect("button_down", $LoadDialog, "popup")
	$Export.connect("button_down", self, "export_level")
	$GraphEdit.connect("connection_request", self, "_on_connection_request")
	$GraphEdit.connect("disconnection_request", self, "_on_disconnection_request")
	$LoadDialog.connect("file_selected", self, "load_dialogs")
	$SaveDialog.connect("file_selected", self, "save_as")


func save_as(file):
	self.save_dialogs(file)


func create_node(typeNode):
	var node = typeNode.instance()
	var position = get_viewport().get_visible_rect().size
	
	var gEdit = get_node(gEditName)
	node.offset.x = position.x/2 +gEdit.scroll_offset.x - node.get_rect().size.x/2
	node.offset.y = position.y/2 + gEdit.scroll_offset.y - node.get_rect().size.y/2
	gEdit.add_child(node)
	node.owner = gEdit


func _on_connection_request(from, from_slot, to, to_slot):
	var gEdit = get_node(gEditName)
	gEdit.connect_node(from, from_slot, to, to_slot)


func _on_disconnection_request(from, from_slot, to, to_slot):
	var gEdit = get_node(gEditName)
	gEdit.disconnect_node(from, from_slot, to, to_slot)


func load_dialogs(file):
	var gEdit = get_node(gEditName)
	#load txt descriptor file:
	var save_game = File.new()
	if not save_game.file_exists(file):
		return # Error! We don't have a save to load.
	gEdit.queue_free()
	
	save_game.open(file, File.READ)
	
	var fileNameScn = save_game.get_line()

	var Edit = load(fileNameScn)
	var algo = Edit.instance()
	add_child(algo)
	move_child(algo,1)
	gEditName = algo.name
	algo.connect("connection_request", self, "_on_connection_request")
	algo.connect("disconnection_request", self, "_on_disconnection_request")
	
	var connections = parse_json(save_game.get_line())
	for connection in connections:
		algo.connect_node(connection.from, connection.from_port, connection.to, connection.to_port)
	
	save_game.close()
	self.current_file = file
	$Export.disabled = false
	

func save_dialogs(file):
	var gEdit = get_node(gEditName)
	var scene = PackedScene.new()
	var result = scene.pack(gEdit)
	if result == OK:
		ResourceSaver.save(file.replace('txt', 'scn'), scene)
	
	var save_game = File.new()
	save_game.open(file, File.WRITE)
	save_game.store_line(file.replace('txt', 'scn'))
	save_game.store_line(to_json(gEdit.get_connection_list()))
	save_game.close()
	self.current_file = file
	$Export.disabled = false


func check_save():
	if self.current_file.empty():
		$SaveDialog.popup()
	else:
		save_dialogs(self.current_file)


func export_level():
	var gEdit = get_node(gEditName)
	var nodes = {}
	for node in gEdit.get_connection_list():
		if not nodes.has(node.from):
			nodes[node.from]=[]
		nodes[node.from].append(node.to)
	
	var file = self.current_file.replace('txt', 'data')
	var save_game = File.new()
	save_game.open(file, File.WRITE)
	for node in gEdit.get_children():
		if not node is GraphNode: continue
		var next_nodes = []
		if nodes.has(node.name):
			next_nodes = nodes[node.name]
		save_game.store_line(node._to_string_node(next_nodes))
	
	save_game.close()
	