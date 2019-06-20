tool
extends Node2D

const Letter = preload("res://Scenarios/Minigames/SopaLetras/Letter.tscn")
export (String) var text = 'detodaslasletrasparecenalgunasquenosiempresoncorrectasytocaadivinar'

var words = {
	"word1": [2,3,4,5,6,7,8,9,10],
	"word2": [22,33,44,55,66]
}
var pairs = [[2,10, 'word1'], [22,66, 'word2'], [55,66, 'word3'], [33, 40, 'word4'], [66, 120, 'word5']]

var initiaded = false
var one_pair = -1
var hovered

func _ready():
	var limit = 12*12
	var index = 0
	for character in text:
		var letra = Letter.instance()
		letra.set_letter(index, character)
		letra.connect("on_click", self, "letter_clicked")
		letra.connect("hovered", self, "set_hovered")
		$GridContainer.add_child(letra)
		index+=1
		if index>=limit:
			break

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
				print("PAIR MATCHED!!")
				for index_letter in words[pair[2]]:
					$GridContainer.get_child(index_letter).set_matched()
		
		letter.unselect()
		$GridContainer.get_child(one_pair).unselect()
		index = -1
	$Selector.visible = initiaded

func set_hovered(letter):
	hovered = letter

func _process(delta):
	if hovered and one_pair!=-1:
		$Selector.points[1].x = $GridContainer.rect_position.x + hovered.rect_position.x + 15
		$Selector.points[1].y = $GridContainer.rect_position.x + hovered.rect_position.y + 15