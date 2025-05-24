extends BaseState

func enter(owner):
	print("Entering DEATH")

func update(owner, delta):
	print(owner.name + " entered Death state")
	owner.queue_free()
