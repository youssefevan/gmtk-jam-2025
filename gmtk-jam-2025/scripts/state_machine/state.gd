extends Node
class_name State

var entity : Card

func enter():
	if get_parent().print_states == true:
		print(name)

func physics_update(delta):
	pass

func exit():
	pass
