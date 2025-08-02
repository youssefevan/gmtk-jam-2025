extends Node2D

@onready var tile_scene = preload("res://scenes/tile.tscn")

var board_pos = 0

func _ready():
	Global.connect("end_combat", start_turn)
	
	for point in range($Path2D.curve.point_count):
		$Path2D.curve.set_point_position(point, $Path2D.curve.get_point_position(point) + global_position)
		
		var tile = tile_scene.instantiate()
		$Tiles.add_child(tile)
		tile.global_position = $Path2D.curve.get_point_position(point)

func start_turn():
	$Button.disabled = false

func _on_button_pressed() -> void:
	var roll = randi_range(1, 6)
	$Number.text = str(roll)
	
	$Button.disabled = true
	
	await get_tree().create_timer(0.3).timeout
	
	for i in range(roll):
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(
			$Path2D/player,
			"global_position",
			$Path2D.curve.get_point_position((board_pos % $Path2D.curve.point_count) + (i+1)),
			0.2
		)
		await tween.finished
	
	board_pos += roll
	
	var current_tile = $Tiles.get_child(board_pos % $Path2D.curve.point_count)
	
	if current_tile.type == "enemy":
		Global.enter_combat()
