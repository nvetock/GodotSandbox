extends BaseState

func enter(owner):
	print("Entering IDLE")

func update(owner, delta):
	if owner.can_see_player():
		owner.change_state("chase")
