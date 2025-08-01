extends Node2D

@export var card_scene = preload("res://scenes/card.tscn")

var rng = RandomNumberGenerator.new()

var deck_comp = {
	"2": 3,
	"3": 3,
	"4": 3,
	"5": 3,
	"6": 3,
	"7": 3,
	"8": 2,
	"9": 2,
	"10": 2,
	"J": 1,
	"Q": 1,
	"K": 1,
	"A": 1,
}

func _ready():
	rng.randomize()

func draw_card():
	var card = card_scene.instantiate()
	
	var value = get_random_card_from_deck()
	
	card.face_value = value
	deck_comp[value] -= 1
	
	add_child(card)
	card.add_to_hand()

func get_random_card_from_deck():
	var value = deck_comp.keys()[rng.randi() % deck_comp.size()]
	
	if deck_comp[value] > 0:
		return value
	else:
		return get_random_card_from_deck()

func _physics_process(delta):
	$Debug.text = str(deck_comp)
