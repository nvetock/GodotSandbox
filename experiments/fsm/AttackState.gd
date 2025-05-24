extends BaseState

func enter(owner):
	print("Entering ATTACK")

func update(owner, delta):
	# Get all objects in radius
	# Apply damage
	# Switch to idle? or death if one time attack
	print(owner.name + " attacking!")
	
	owner.change_state("idle")
