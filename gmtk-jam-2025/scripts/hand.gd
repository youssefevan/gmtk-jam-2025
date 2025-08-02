extends Path2D
class_name Hand

var curve_length
var deck

@onready var card_scene = preload("res://scenes/card.tscn")
@onready var turn_manager = preload("res://resources/turn_manager.tres")

func _ready():
	Global.connect("end_combat", end_combat)
	deck = get_tree().get_first_node_in_group("Deck")
	update_card_positions()
	
	for i in range(7):
		update_hand()

func update_card_positions():
	curve.get_baked_points()
	curve_length = curve.get_baked_length()
	
	for i in range(get_child_count()):
		if get_child_count() == 1:
			var pos = curve.sample_baked(curve_length/2)
			
			get_child(i).target_position = pos
		else:
			var pos_along_curve = i / float(get_child_count() - 1)
			var dist = pos_along_curve * curve_length
			var pos = curve.sample_baked(dist)
			
			get_child(i).target_position = pos

func update_hand():
	deck.draw_card()

func end_combat():
	pass
