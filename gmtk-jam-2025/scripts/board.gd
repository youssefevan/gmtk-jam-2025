extends Node2D


func _on_button_pressed() -> void:
	$Path2D/PathFollow2D.progress += 25
