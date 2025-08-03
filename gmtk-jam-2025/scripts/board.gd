extends Node2D

@onready var tile_scene = preload("res://scenes/tile.tscn")
@export var suits : Array[Texture2D]

var board_pos = 0

func _ready():
	Global.connect("end_combat", start_turn)
	Global.connect("start_combat", start_combat)
	
	for point in range($Path2D.curve.point_count):
		$Path2D.curve.set_point_position(point, $Path2D.curve.get_point_position(point) + global_position)
	
	set_tiles()

func set_tiles():
	for child in $Tiles.get_child_count():
		$Tiles.get_child(child).call_deferred("free")
	
	for point in range($Path2D.curve.point_count):
		var tile = tile_scene.instantiate()
		if point == 0:
			tile.type = "boss"
		else:
			match Global.rng.randi_range(0, 3):
				0:
					tile.type = "card"
				1:
					tile.type = "chance"
				2:
					tile.type = "enemy"
				3:
					tile.type = "move"
		
		$Tiles.add_child(tile)
		tile.global_position = $Path2D.curve.get_point_position(point)


func start_turn():
	var tween = get_tree().create_tween()
	tween.tween_property($boardTexture, "modulate", Color.WHITE, 0.5)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Path2D/player/Sprite2D, "modulate", $Path2D/player.start_color, 0.5)
	
	await get_tree().create_timer(0.5).timeout
	
	$Button.disabled = false
	
	var tween3 = get_tree().create_tween()
	tween3.set_trans(Tween.TRANS_CUBIC)
	tween3.tween_property($Button, "modulate", Color("ffffffff"), 0.5)
	await tween3.finished

func _on_button_pressed() -> void:
	handle_movement(Global.rng.randi_range(1, 6))

func handle_movement(roll):
	$Number.frame = abs(roll)
	
	$Roll.play()
	
	$Button.disabled = true
	$Number.visible = true
	
	await get_tree().create_timer(0.3).timeout
	print(roll)
	if (board_pos + roll) < $Path2D.curve.point_count:
		for i in range(abs(roll)):
			var tween = get_tree().create_tween()
			tween.set_trans(Tween.TRANS_CUBIC)
			if roll >= 0:
				tween.tween_property(
					$Path2D/player,
					"global_position",
					$Path2D.curve.get_point_position(board_pos + (i+1)),
					0.2
				)
			else:
				tween.tween_property(
					$Path2D/player,
					"global_position",
					$Path2D.curve.get_point_position(board_pos - (i+1)),
					0.2
				)
			$Move.play()
			await tween.finished
		board_pos += roll
	else:
		for i in range($Path2D.curve.point_count - board_pos - 1):
			var tween = get_tree().create_tween()
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(
				$Path2D/player,
				"global_position",
				$Path2D.curve.get_point_position(board_pos + (i+1)),
				0.2
			)
			$Move.play()
			await tween.finished
		
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(
			$Path2D/player,
			"global_position",
			$Path2D.curve.get_point_position(0),
			0.2
		)
		await tween.finished
		
		board_pos = 0
		Global.new_loop()
		set_tiles()
	
	var current_tile = $Tiles.get_child(board_pos % $Path2D.curve.point_count)
	
	if current_tile.type == "enemy":
		enemy_encounter(false)
		
	elif current_tile.type == "boss":
		enemy_encounter(true)
	
	elif current_tile.type == "card":
		add_card_encounter()
	
	elif current_tile.type == "chance":
		pick_encounter()
	
	elif current_tile.type == "move":
		move_encounter()

func move_encounter():
	handle_movement(Global.rng.randi_range(-6, 6))

func add_card_encounter():
	var suit = Global.rng.randi_range(0, 4)
	var amount = Global.rng.randi_range(2, 5)
	match suit:
		0:
			Global.deck_comp["Physical"] += amount
		1:
			Global.deck_comp["Freeze"] += amount
		2:
			Global.deck_comp["Heal"] += amount
		3:
			Global.deck_comp["Fire"] += amount
		4:
			Global.deck_comp["Poison"] += amount
	
	$AddCard/Label.text = str("+", amount, " cards")
	$AddCard/Card/Suit.texture = suits[suit]
	$AddCard/Animator.play("show")
	await $AddCard/Animator.animation_finished
	start_turn()

func pick_encounter():
	var encounter = Global.rng.randi_range(0, 2)
	match encounter:
		0:
			add_card_encounter()
		1:
			enemy_encounter(false)
		2:
			move_encounter()

func enemy_encounter(is_boss):
	var tween = get_tree().create_tween()
	tween.tween_property($boardTexture, "modulate", Color("ff4726"), 0.5)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Path2D/player/Sprite2D, "modulate", Color("1b908f"), 0.5)
	
	if is_boss:
		get_parent().boss_fight = true
	else:
		get_parent().boss_fight = false
	
	Global.enter_combat()

func start_combat():
	$Number.visible = false
	var tween3 = get_tree().create_tween()
	tween3.set_trans(Tween.TRANS_CUBIC)
	tween3.tween_property($Button, "modulate", Color("ffffff00"), 0.5)
