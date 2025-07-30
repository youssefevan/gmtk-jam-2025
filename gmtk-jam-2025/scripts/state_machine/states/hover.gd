extends State

func physics_update(delta):
	super.physics_update(delta)
	
	entity.scale = lerp(entity.scale, Vector2(1.2, 1.2), entity.anim_speed * delta)
	
	if !entity.mouse_hovering:
		return entity.idle
	
	
	if Input.is_action_just_pressed("click"):
		return entity.grab
