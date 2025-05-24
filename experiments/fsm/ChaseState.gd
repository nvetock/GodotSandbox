extends BaseState

func enter(owner):
	print("Entering CHASE")

func update(owner, delta):
	if not owner.can_see_player():
		owner.change_state("idle")
		return
	
	var direction = (owner.player.global_position - owner.global_position).normalized()
	owner.velocity = direction * owner.speed
	owner.move_and_slide()
