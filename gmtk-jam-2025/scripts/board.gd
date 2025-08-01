extends Node2D

var board_pos = 0

func _on_button_pressed() -> void:
	var roll = randi_range(1, 6)
	$Button.text = str(roll)
	
	print($Path2D.curve.get_point_position(0))
	
	var tween = get_tree().create_tween()
	tween.tween_property($Path2D/PathFollow2D, "progress", $Path2D/PathFollow2D.progress + 25 * roll, 0.2 * roll)
	$Button.disabled = true
	await tween.finished
	$Button.disabled = false
