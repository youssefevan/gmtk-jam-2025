extends State

func enter():
	super.enter()
	entity.starting_position = entity.global_position

func physics_update(delta):
	super.physics_update(delta)
	
	entity.scale = lerp(entity.scale, Vector2(1.1, 1.1), entity.anim_speed * delta)
	
	entity.global_position = lerp(
		entity.global_position,
		entity.get_global_mouse_position(),
		entity.anim_speed * delta
	)
	
	if Input.is_action_just_released("click"):
		if entity.playable:
			return entity.play
		else:
			return entity.idle
