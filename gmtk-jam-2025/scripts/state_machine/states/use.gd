extends State

func enter():
	super.enter()
	entity.get_parent().remove_child(entity)

func physics_update(delta):
	entity.scale = lerp(entity.scale, Vector2(1.0, 1.0), entity.anim_speed * delta)
