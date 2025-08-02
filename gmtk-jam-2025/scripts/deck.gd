extends Node2D

@export var card_scene = preload("res://scenes/card.tscn")

func _ready():
	Global.connect("end_combat", end_combat)

func draw_card():
	var card = card_scene.instantiate()
	
	var value = Global.get_random_card_from_deck()
	
	card.face_value = value
	Global.deck_comp[value] -= 1
	
	add_child(card)
	card.add_to_hand()

func _physics_process(delta):
	$Debug.text = str(Global.deck_comp)
	$PlayerStats.text = str("HP: ", Global.player_health)

func end_combat():
	$AnimationPlayer.play("exit")
