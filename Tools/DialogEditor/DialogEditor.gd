extends Control
var sgn = load("res://Tools/DialogEditor/DialogNode.tscn")
var optionNode = load("res://Tools/DialogEditor/OptionElement.tscn")

var current_file = ''

var gEditName = 'GraphEdit'
onready var gEdit = get_node(gEditName)

func _ready():
	$CreateConversationNode.connect("button_down", self, "create_node", [sgn])
	$CreateOptionNode.connect("button_down", self, "create_node", [optionNode])
	$Save.connect("button_down", self, "check_save")
	$SaveAs.connect("button_down", $SaveDialog, "popup")
	$Load.connect("button_down", $LoadDialog, "popup")
	$GraphEdit.connect("connection_request", self, "_on_connection_request")
	
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
	
	var connections = parse_json(save_game.get_line())
	for connection in connections:
		algo.connect_node(connection.from, connection.from_port, connection.to, connection.to_port)
	
	save_game.close()
	self.current_file = file
	

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


func check_save():
	if self.current_file.empty():
		$SaveDialog.popup()
	else:
		save_dialogs(self.current_file)

