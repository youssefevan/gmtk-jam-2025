extends Node

signal start_combat
signal end_combat

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
		return "empty"
	
	var pick = rng.randi() % total
	
	for card_type in deck_comp.keys():
		pick -= deck_comp[card_type]
		if pick < 0:
			return card_type

func enter_combat():
	start_combat.emit()
	print("enter combat")

func exit_combat():
	end_combat.emit()
	print("exit combat")

func game_over():
	exit_combat()
	print('game over')
