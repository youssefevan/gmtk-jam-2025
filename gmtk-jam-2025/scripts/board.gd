extends Node2D

var board_pos = 0

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
	$Button.disabled = false
