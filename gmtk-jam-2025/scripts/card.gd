extends Area2D
class_name Card

@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var hover = $StateManager/Hover
@onready var grab = $StateManager/Grab
@onready var select = $StateManager/Select
@onready var use = $StateManager/Use
@onready var discard = $StateManager/Discard

var mouse_hovering := false
var mouse_dragging := false

var anim_speed := 15.0
var usable := false

func _ready() -> void:
	states.init(self)

func _physics_process(delta: float) -> void:
	states.physics_update(delta)

func _on_mouse_entered() -> void:
	mouse_hovering = true

func _on_mouse_exited() -> void:
	mouse_hovering = false
