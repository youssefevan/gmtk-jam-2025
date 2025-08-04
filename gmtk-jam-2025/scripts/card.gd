extends Node2D
class_name Card

@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var hover = $StateManager/Hover
@onready var grab = $StateManager/Grab
@onready var select = $StateManager/Select
@onready var play = $StateManager/Play
@onready var discard = $StateManager/Discard

@onready var turn_manager = preload("res://resources/turn_manager.tres")

@export var suits : Array[Texture2D]
@export var face_value := "Fire"

@onready var animator = $AnimationPlayer

@onready var audio_play = $Play
@onready var audio_grab = $Grab

var damage

var target

var mouse_hovering := false
var mouse_dragging := false

var anim_speed := 15.0
var playable := false

var hand : Hand
var hand_position : int

var target_position

var in_combat := true

@onready var base = $Base

func _ready() -> void:
	states.init(self)
	hand = get_tree().get_first_node_in_group("Hand")
	
	damage = Global.rng.randi_range(2, 5) + Global.loop
	
	Global.connect("end_combat", end_combat)
	
	$Suit.texture = suits[calculate_suit()]
	
	if calculate_suit() == 0 or calculate_suit() == 2:
		$Number.text = str(damage)
	else:
		$Number.visible = false

func calculate_suit():
	match face_value:
		"Fire":
			return 3
		"Freeze":
			return 1
		"Heal":
			return 2
		"Poison":
			return 4
		_:
			return 0

func _physics_process(delta: float) -> void:
	states.physics_update(delta)

func remove_from_hand(pos):
	hand_position = get_index()
	var new_parent = hand.get_parent()
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = pos

func add_to_hand():
	var global_pos = global_position
	get_parent().remove_child(self)
	hand.add_child(self)
	hand.update_card_positions()
	if hand_position and (hand.get_child_count()-1) >= hand_position:
		hand.move_child(self, hand_position)
	position = hand.to_local(global_pos)

func attack():
	if target:
		match face_value:
			"Freeze":
				target.apply_status("frozen")
			"Fire":
				target.apply_status("burned")
			"Poison":
				target.apply_status("poisoned")
			"Heal":
				print(get_parent().heal_anim())
				Global.player_health += damage
			_:
				target.take_damage(damage)
	
	turn_manager.start_enemy_turn	

func return_to_deck():
	if states.current_state != play and states.current_state != discard:
		Global.deck_comp[face_value] += 1

func end_combat():
	playable = false
	in_combat = false
	return_to_deck()

func _on_area_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(2):
		playable = true
		target = area

func _on_area_area_exited(area: Area2D) -> void:
	if area.get_collision_layer_value(2):
		playable = false

func _on_base_mouse_entered():
	mouse_hovering = true

func _on_base_mouse_exited():
	mouse_hovering = false
