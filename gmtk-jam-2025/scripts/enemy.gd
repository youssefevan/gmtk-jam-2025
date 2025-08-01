extends Area2D
class_name Enemy

@export var max_health := 30
@export var attack_power := 3
@export var block_strength := 0.1 # percentage of damage blocked when shielding

@export var type := "normal"

@onready var turn_manager = preload("res://resources/turn_manager.tres")

var status = {
	"frozen": false,
	"burned": false,
}

var health : int

func _ready():
	health = max_health
	update_stats()
	turn_manager.connect("start_enemy_turn", take_turn)

func update_stats():
	$Stats/Health.text = str("HP: ", health)
	$Stats/Attack.text = str("AT: ", attack_power)

func take_turn():
	update_status()
	await get_tree().create_timer(0.9).timeout
	
	if status["frozen"] == false:
		play_attack()
	else:
		print("frozen! turn skipped")
		status["frozen"] = false
		turn_manager.turn = turn_manager.turn_type.PLAYER

func apply_status(type):
	status[type] = true
	update_status()

func update_status():
	$Status/Frozen.visible = status["frozen"]
	$Status/Burned.visible = status["burned"]

func play_attack():
	var tween3 = get_tree().create_tween()
	tween3.set_trans(Tween.TRANS_CUBIC)
	tween3.tween_property($Sprite, "global_position", $Sprite.global_position - Vector2(0, 16), 0.2)
	await tween3.finished
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Sprite, "global_position", $Sprite.global_position + Vector2(0, 32), 0.075)
	await tween.finished
	
	# deal damage
	attack()
	
	turn_manager.turn = turn_manager.turn_type.PLAYER
	
	var tween2 = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property($Sprite, "global_position", $Sprite.global_position - Vector2(0, 16), 0.2)
	await tween2.finished

func attack():
	pass
	
	#deck.take_damage(attack_power)

func take_damage(incoming_damage):
	pass
	#var net_damage = incoming_damage
	#if blocking:
		#net_damage = incoming_damage - floor(incoming_damage*block_stength)
	#health -= net_damage
	#check for death
