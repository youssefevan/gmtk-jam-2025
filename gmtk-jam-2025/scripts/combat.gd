extends Node2D

@onready var enemy = preload("res://scenes/enemy.tscn")

var turn_manager = load("res://resources/turn_manager.tres")

var boss_fight := false

func _ready():
	turn_manager.connect("start_player_turn", start_player_turn)
	turn_manager.connect("start_enemy_turn", start_enemy_turn)
	
	Global.connect("start_combat", start_combat)
	Global.connect("game_end", game_end)

func start_player_turn():
	pass

func start_enemy_turn():
	pass

func _physics_process(delta):
	$Loop.text = str("Loop: ", Global.loop)

func start_combat():
	var e = enemy.instantiate()
	e.boss = boss_fight
	$EnemySpawn.add_child(e)
	turn_manager.turn = turn_manager.turn_type.PLAYER

func game_end():
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_DISABLED
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color.BLACK, 1.0)
	await tween.finished
	
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func heal_anim():
	$AnimationPlayer.play("heal")
