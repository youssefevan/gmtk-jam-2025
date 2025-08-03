extends Node2D


func _on_button_pressed():
	Global.reset()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
