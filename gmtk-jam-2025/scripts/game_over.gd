extends Node2D

func _ready():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color("ffffffff"), 1.0)
	
	$VBox/Title2.text = str("You ran out of cards or health")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
