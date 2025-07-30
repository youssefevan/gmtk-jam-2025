extends State

func enter():
	super.enter()
	entity.remove_from_hand(entity.global_position)

func physics_update(delta):
	entity.scale = lerp(entity.scale, Vector2(1.0, 1.0), entity.anim_speed * delta)
