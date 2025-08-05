extends Node

signal start_combat
signal end_combat
signal start_new_loop
signal game_end

var player_health := 20
var coins := 0

@onready var music = preload("res://audio/cave themeb4.ogg")

var starting_deck = {
	"Physical": 12,
	"Fire": 4,
	"Freeze": 4,
	"Poison": 4,
	"Heal": 4,
}

var deck_comp

var rng = RandomNumberGenerator.new()

var loop := 1

func _ready():
	reset()
	rng.randomize()
	
	var audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
	audio_player.volume_db = -5.0
	audio_player.stream = music
	audio_player.play()

func reset():
	deck_comp = starting_deck
	loop = 1
	player_health = 20
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

func new_loop():
	loop += 1
	start_new_loop.emit()
	print("new loop")

func game_over():
	exit_combat()
	print('test')
	game_end.emit()
