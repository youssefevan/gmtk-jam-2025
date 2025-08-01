extends Resource
class_name TurnManager

signal start_player_turn
signal start_enemy_turn

enum turn_type {PLAYER, ENEMY}
var turn : turn_type:
	set(value):
		turn = value
		match turn:
			turn_type.PLAYER: start_player_turn.emit()
			turn_type.ENEMY: start_enemy_turn.emit()
