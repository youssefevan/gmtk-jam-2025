extends State

func enter():
	super.enter()
	entity.animator.play("discard")
	await entity.animator.animation_finished
	
	entity.queue_free()
