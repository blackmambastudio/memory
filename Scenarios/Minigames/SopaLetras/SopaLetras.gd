tool
extends Node2D

const Letter = preload("res://Scenarios/Minigames/SopaLetras/Letter.tscn")
signal word_match

export (Array) var words = [
	{"word":"remember", "col": 2, "row": 2, "direction": 2},
	{"word":"salvation", "col": 0, "row": 0, "direction": 4},
	{"word":"future", "col": 2, "row": 5, "direction": 4},
	{"word":"flower", "col": 2, "row": 5, "direction": 3},
	{"word":"past", "col": 9, "row": 4, "direction": 6},
	{"word":"peace", "col": 9, "row": 4, "direction": 4},
]

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
	insert_words()

func letter_clicked(index):
	if index == one_pair: return
	initiaded = !initiaded
	var letter = $GridContainer.get_child(index)
	if initiaded:
		letter.select()
		one_pair = index
		$Selector.points[0].x = $GridContainer.rect_position.x + letter.rect_position.x + 15
		$Selector.points[0].y = $GridContainer.rect_position.x + letter.rect_position.y + 15
	else:
		# search pair
		for pair in pairs:
			if (pair[0] == one_pair or pair[0] == index) and \
			   (pair[1] == one_pair or pair[1] == index):
				emit_signal("word_match", pair[2])
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
		$Selector.points[1].x = $GridContainer.rect_position.x + hovered.rect_position.x + 15
		$Selector.points[1].y = $GridContainer.rect_position.x + hovered.rect_position.y + 15

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
	for w in words:
		print(w)
		var text = w["word"]
		var col = w["col"]
		var row = w["row"]
		var direction = w["direction"]
		
		var _word = []
		
		for letter in text:
			var index = col + row*12
			_word.append(index)
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
		pairs.append([_word[0], _word[-1], text])







