extends Node2D

@export var card_scene = preload("res://scenes/card.tscn")

func draw_card():
	var card = card_scene.instantiate()
	add_child(card)
	card.add_to_hand()
