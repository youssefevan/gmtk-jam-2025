extends State

var done := false

func enter():
	super.enter()
	entity.turn_manager.turn = entity.turn_manager.turn_type.ENEMY
	entity.remove_from_hand(entity.global_position)
	
	entity.hand.update_hand()
	
	done = false
	move_to_target()

func physics_update(delta):
	entity.scale = lerp(entity.scale, Vector2(1.0, 1.0), entity.anim_speed * delta)
	
	if done:
		return entity.discard


func move_to_target():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(entity, "global_position", entity.target.global_position, 0.3)
	await tween.finished
	
	await get_tree().create_timer(0.1).timeout
	
	play_anim()

func play_anim():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(entity, "global_position", entity.global_position - Vector2(0, 16), 0.075)
	await tween.finished
	
	entity.attack()
	
	var tween2 = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property(entity, "global_position", entity.global_position + Vector2(0, 16), 0.2)
	await tween2.finished
	
	await get_tree().create_timer(0.1).timeout
	
	done = true
