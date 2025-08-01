extends State

func enter():
	super.enter()
	entity.call_deferred("free")
