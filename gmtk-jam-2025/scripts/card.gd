extends Control
class_name Card

@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var hover = $StateManager/Hover
@onready var grab = $StateManager/Grab
@onready var select = $StateManager/Select
@onready var play = $StateManager/Play
@onready var discard = $StateManager/Discard

var mouse_hovering := false
var mouse_dragging := false

var anim_speed := 15.0
var playable := false

var hand : Hand
var hand_position : int

func _ready() -> void:
	states.init(self)
	hand = get_parent()

func _physics_process(delta: float) -> void:
	states.physics_update(delta)

func remove_from_hand(pos):
	hand_position = get_index()
	var new_parent = hand.get_parent()
	get_parent().remove_child(self)
	var global_pos = global_position
	new_parent.add_child(self)
	global_position = pos

func add_to_hand():
	get_parent().remove_child(self)
	hand.add_child(self)
	hand.move_child(self, hand_position)

func _on_area_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(2):
		playable = true

func _on_area_area_exited(area: Area2D) -> void:
	if area.get_collision_layer_value(2):
		playable = false

func _on_texture_mouse_entered() -> void:
	mouse_hovering = true

func _on_texture_mouse_exited() -> void:
	mouse_hovering = false
