extends Area2D
class_name Enemy

@export var max_health := 6
@export var attack_power := 3
@export var block_strength := 0.5 # percentage of damage blocked when shielding

@export var type := "normal"

@onready var turn_manager = preload("res://resources/turn_manager.tres")

var status = {
	"frozen": false,
	"burned": 0,
	"poisoned": false,
}

var health : int
var blocking := false

var boss := false

func _ready():
	if !boss:
		max_health = Global.rng.randi_range(3, 6) * Global.loop
		attack_power = Global.rng.randi_range(1, 4) + (Global.loop * 2)
	else:
		max_health = Global.rng.randi_range(3, 6) * Global.loop * 2
		attack_power = Global.rng.randi_range(1, 4) + (Global.loop * 4)
		$Sprite.texture = load("res://sprites/boss.png")
	
	health = max_health
	update_stats()
	turn_manager.connect("start_enemy_turn", take_turn)
	Global.connect("end_combat", end_combat)
	Global.connect("game_end", game_end)

func update_stats():
	$Stats/Health.text = str("HP: ", health)
	$Stats/Attack.text = str("AT: ", attack_power)

func take_turn():
	await get_tree().create_timer(1.0).timeout
	update_status()
	
	if health > 0:
		if status["burned"] > 0:
			status["burned"] -= 1
			take_burn_damage()
			await get_tree().create_timer(0.75).timeout
			update_status()
	
		if status["frozen"] == false:
			var choose_block = Global.rng.randi_range(0, 4)
			if choose_block != 0:
				play_attack()
			else:
				print("blocking! turn skipped")
				blocking = true
				
				await get_tree().create_timer(0.4).timeout
				$Blocking.visible = true
				turn_manager.turn = turn_manager.turn_type.PLAYER
		else:
			print("frozen! turn skipped")
			status["frozen"] = false
			turn_manager.turn = turn_manager.turn_type.PLAYER

func take_burn_damage():
	await get_tree().create_timer(0.3).timeout
	
	$Burn.play()
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Sprite, "scale", Vector2(0.9, 0.9), 0.075)
	await tween.finished
	
	health -= 1
	health = clampi(health, 0, 100)
	update_stats()
	
	if health <= 0:
		die()
	
	var tween2 = get_tree().create_tween()
	tween2.set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property($Sprite, "scale", Vector2(1.0, 1.0), 0.2)
	await tween2.finished

func apply_status(type):
	if type == "burned":
		status[type] = 3
	else:
		status[type] = true
	update_status()

func update_status():
	$Status/Frozen.visible = status["frozen"]
	$Status/Poisoned.visible = status["poisoned"]
	if status["burned"] > 0:
		$Status/Burned.visible = true
	else:
		$Status/Burned.visible = false

func play_attack():
	$Hit.play()
	if health > 0:
		#print("aatac")
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
	Global.player_health -= attack_power
	if Global.player_health <= 0:
		Global.game_over()

func take_damage(incoming_damage):
	var net_damage = incoming_damage
	
	if status["poisoned"] == true:
		net_damage = ceil(net_damage * 1.5)
		status["poisoned"] = false
		
	if blocking:
		net_damage = incoming_damage - floor(incoming_damage*block_strength)
		blocking = false
		
		await get_tree().create_timer(0.3).timeout
		$Blocking.visible = false
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Sprite, "scale", Vector2(0.9, 0.9), 0.075)
	await tween.finished
	
	var tween2 = get_tree().create_tween()
	tween2.set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property($Sprite, "scale", Vector2(1.0, 1.0), 0.2)
	await tween2.finished
	
	#print(incoming_damage, " --> ", net_damage)
	health -= net_damage
	health = clampi(health, 0, 100)
	
	update_stats()
	
	if health <= 0:
		die()

func die():
	$Animator.play('die')
	Global.exit_combat()

func end_combat():
	pass

func game_end():
	call_deferred("queue_free")
