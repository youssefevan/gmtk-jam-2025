extends Node2D

@onready var enemy = preload("res://scenes/enemy.tscn")

var turn_manager = load("res://resources/turn_manager.tres")

func _ready():
	turn_manager.connect("start_player_turn", start_player_turn)
	turn_manager.connect("start_enemy_turn", start_enemy_turn)
	
	Global.connect("start_combat", start_combat)

func start_player_turn():
	pass

func start_enemy_turn():
	pass

func start_combat():
	var e = enemy.instantiate()
	$EnemySpawn.add_child(e)
	turn_manager.turn = turn_manager.turn_type.PLAYER
