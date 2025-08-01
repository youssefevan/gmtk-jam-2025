extends Node2D

var board_pos = 0

func _on_button_pressed() -> void:
	
	$Path2D/PathFollow2D.progress += 25
