extends BaseState

var attack_started := false

func enter(owner):
	print("Entering ATTACK")
	attack_started = false

func update(owner, delta):
	if attack_started:
		return
	
	if owner.attack_cooldown.time_left > 0:
		return
	
	if owner.player and owner.player.has_node("HealthComponent") and owner.attack_cooldown:
		attack_started = true
		await owner.get_tree().create_timer(0.3).timeout
		
		print(owner.name + " attacking!")
W		var p_health = owner.player.get_node("HealthComponent")
		p_health.take_damage(1)
	
		owner.attack_cooldown.start()
		owner.change_state("chase")


# Get all objects in radius
# Apply damage
# Switch to idle? or death if one time attack
