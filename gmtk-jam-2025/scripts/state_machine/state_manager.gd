extends Node
class_name StateManager

@export var starting_state : State
@export var print_states := true

var current_state : State

func change_state(new_state : State):
	if current_state:
		current_state.exit()
	
	if current_state:
		current_state = null
	
	current_state = new_state
	current_state.enter()

func init(entity : Card):
	for child in get_children():
		child.entity = entity
	
	if starting_state != null:
		change_state(starting_state)
	else:
		print("No starting state given...defaulting to first child node...")
		change_state(get_child(0))

func physics_update(delta):
	var new_state = current_state.physics_update(delta)
	if new_state:
		change_state(new_state)
#
func input(event : InputEvent):
	if current_state is State:
		var new_state = current_state.input(event)
		if new_state:
			change_state(new_state)
