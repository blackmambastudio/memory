tool
extends Control

onready var VariableBoard = get_node("/root/VariableBoard")

const Letter = preload("res://Scenarios/Minigames/SopaLetras/Letter.tscn")
signal word_match


var categories = {
	"laundry": [
		{"word":"remember", "col": 1, "row": 2, "direction": 2},
		{"word":"laundry", "col": 0, "row": 1, "direction": 4},
		{"word":"bleach", "col": 2, "row": 5, "direction": 2},
		{"word":"wash", "col": 4, "row": 7, "direction": 2},
		{"word":"mop", "col": 9, "row": 9, "direction": 2},
		{"word":"remove", "col": 10, "row": 11, "direction": 6}
	],
	"appliances": [
		{"word":"remember", "col": 0, "row": 1, "direction": 4},
		{"word":"frypan", "col": 2, "row": 9, "direction": 2},
		{"word":"toaster", "col": 9, "row": 3, "direction": 5},
		{"word":"dryer", "col": 6, "row": 8, "direction": 2},
		{"word":"vacuum", "col": 3, "row": 1, "direction": 2},
		{"word":"pump", "col": 8, "row": 3, "direction": 0}
	],
	"gardentools": [
		{"word":"remember", "col": 8, "row": 10, "direction": 6},
		{"word":"shovel", "col": 9, "row": 2, "direction": 4},
		{"word":"gloves", "col": 2, "row": 2, "direction": 4},
		{"word":"pruner", "col": 4, "row": 9, "direction": 2},
		{"word":"shears", "col": 9, "row": 2, "direction": 6},
		{"word":"strimmer", "col": 3, "row": 0, "direction": 3}
	], 
	"kitchen":[
		{"word":"remember", "col": 1, "row": 6, "direction": 2},
		{"word":"apron", "col": 9, "row": 2, "direction": 4},
		{"word":"napkin", "col": 11, "row": 6, "direction": 4},
		{"word":"plates", "col": 9, "row": 0, "direction": 5},
		{"word":"knife", "col": 8, "row": 10, "direction": 7},
		{"word":"blender", "col": 2, "row": 1, "direction": 4}
	]
}

var words =[]

export(String, "laundry", "appliances", "gardentools", "kitchen") var level = "kitchen"
var word_indexes = {}
var pairs = []

var initiaded = false
var one_pair = -1
var hovered

func _ready():
	var limit = 12*12
	var index = 0
	var text = populate()
	
	for character in text:
		var letra = Letter.instance()
		letra.set_letter(index, character)
		letra.connect("on_click", self, "letter_clicked")
		letra.connect("hovered", self, "set_hovered")
		$GridContainer.add_child(letra)
		index+=1
		if index>=limit:
			break
	
	$MiniCover.connect("button_down", self, "show_cover")
	$Turn.connect("button_down", self, "turn_cover")
	level = VariableBoard.get_value("wordsearch_level")
	if level == null:
		level = "kitchen"

	words = categories[level]
	insert_words()

func load_level(level):
	print("load level", level)
	print("previous level vs ", self.level, " - ", level)
	if self.level == level:
		return
	self.level = level
	$Turn.visible = level == 'kitchen'
	$MiniCover.visible = level == 'kitchen'
	var text = populate()
	var index = 0
	for letra in $GridContainer.get_children():
		letra.set_text(text[index])
		letra.unmatched()
		index += 1
	pairs = []
	words = []
	one_pair = -1
	words = categories[level]
	insert_words()

func letter_clicked(index):
	if index == one_pair: return
	initiaded = !initiaded
	var letter = $GridContainer.get_child(index)
	if initiaded:
		letter.select()
		one_pair = index
		$Selector.points[0].x = $GridContainer.rect_position.x + letter.rect_position.x + $GridContainer.margin_left - 10
		$Selector.points[0].y = $GridContainer.rect_position.x + letter.rect_position.y +  $GridContainer.margin_top - 10
	else:
		# search pair
		for pair in pairs:
			if !pair[4] and (pair[0] == one_pair or pair[0] == index) and \
			   (pair[1] == one_pair or pair[1] == index):
				word_match(pair)
				for index_letter in word_indexes[pair[2]]:
					$GridContainer.get_child(index_letter).set_matched()
		
		letter.unselect()
		$GridContainer.get_child(one_pair).unselect()
		one_pair = -1
	$Selector.visible = initiaded

func set_hovered(letter):
	hovered = letter

func _process(delta):
	if hovered and one_pair!=-1:
		$Selector.points[1].x = $GridContainer.rect_position.x + hovered.rect_position.x +  $GridContainer.margin_left - 10
		$Selector.points[1].y = $GridContainer.rect_position.x + hovered.rect_position.y +  $GridContainer.margin_top - 10

func populate():
	var vocals = 'aeiou'
	var consonants = 'bcdfghjklmnpqrstvwxyz'
	var text = ''
	for i in range(0, 144):
		var choice = randi()%100
		var letter = ''
		if choice < 40:
			letter = vocals[randi()%vocals.length()]
		else:
			letter = consonants[randi()%consonants.length()]
		text += letter
	
	return text


func insert_words():
	var word_list_index = 0
	for w in words:
		var text = w["word"]
		var col = w["col"]
		var row = w["row"]
		var direction = w["direction"]
		
		var _word = []
		
		for letter in text:
			var index = col + row*12
			_word.append(index)
			print("set letter: ", index, "-", letter)
			$GridContainer.get_child(index).set_text(letter)
			if direction == 7 || direction == 0 || direction == 1:
				row -= 1
			if direction == 3 || direction == 4 || direction == 5:
				row += 1
			if direction == 1 || direction == 2 || direction == 3:
				col += 1
			if direction == 5 || direction == 6 || direction == 7:
				col -= 1

		word_indexes[text] = _word
		pairs.append([_word[0], _word[-1], text, word_list_index, false])
		
		# insert word in the wordlist
		if text != 'remember':
			$WordList.get_child(word_list_index).text = text
			$WordList.get_child(word_list_index).modulate = Color('#444470')
			word_list_index += 1
		else:
			pairs[-1][3] = -1

func word_match(pair):
	pair[4] = true
	$SFX_Select.playsound()
	var word_list_index = pair[3]
	if word_list_index != -1:
		$WordList.get_child(word_list_index).modulate = Color(0.7,0.2,0.2)
	
	if pair[2] == 'remember':
		VariableBoard.add_value("remember_times", 1)
	
	emit_signal("word_match", pair[2])


func show_cover():
	$SFX_Card.playsound()
	$Cover.visible = not $Cover.visible

func turn_cover():
	if $Cover.visible:
		$SFX_Turn.playsound()
		$Cover.rotate(PI/4)


