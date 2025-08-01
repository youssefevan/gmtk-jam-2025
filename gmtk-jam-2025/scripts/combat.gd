extends Node2D

var turn_manager = load("res://resources/turn_manager.tres")

func _ready():
	turn_manager.connect("start_player_turn", start_player_turn)
	turn_manager.connect("start_enemy_turn", start_enemy_turn)

func start_player_turn():
	pass

func start_enemy_turn():
	pass
