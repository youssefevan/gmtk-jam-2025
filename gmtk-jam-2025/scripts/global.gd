extends Node

signal return_cards_to_deck

var player_health := 30

var deck_comp = {
	"Physical": 12,
	"Fire": 4,
	"Freeze": 4,
	"Poison": 4,
	"Heal": 2,
}

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func get_random_card_from_deck():
	var total = 0
	
	for count in deck_comp.values():
		total += count
	
	if total == 0:
		print("no mas")
	
	var pick = rng.randi() % total
	
	for card_type in deck_comp.keys():
		pick -= deck_comp[card_type]
		if pick < 0:
			return card_type

func exit_combat():
	return_cards_to_deck.emit()
	print("exit combat")
