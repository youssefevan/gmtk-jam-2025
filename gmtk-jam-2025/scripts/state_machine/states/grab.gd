extends State

var hand

func enter():
	super.enter()
	entity.remove_from_hand(entity.get_global_mouse_position())
	entity.hand.update_card_positions()
	
	entity.audio_grab.play()

func physics_update(delta):
	super.physics_update(delta)
	
	entity.scale = lerp(entity.scale, Vector2(1.1, 1.1), entity.anim_speed * delta)
	entity.global_position = lerp(
		entity.global_position,
		entity.get_global_mouse_position(),
		entity.anim_speed * delta
	)
	
	if entity.playable:
		if entity.turn_manager.turn == entity.turn_manager.turn_type.PLAYER:
			entity.base.modulate = Color("ffffc5")
		else:
			entity.base.modulate = Color("a1d6ff")
	else:
		entity.base.modulate = Color.WHITE
	
	if Input.is_action_just_released("click"):
		if entity.playable and entity.in_combat:
			if entity.turn_manager.turn == entity.turn_manager.turn_type.PLAYER:
				return entity.play
			else:
				entity.add_to_hand()
				return entity.idle
		else:
			entity.add_to_hand()
			return entity.idle

func exit():
	entity.hand.update_card_positions()
	entity.base.modulate = Color.WHITE
