extends CharacterBody2D

enum State { IDLE, CHASE, ATTACK, DEATH }
var current_state: State = State.IDLE

@export var speed := 60
@export var attack_range := 16
@export var attack_damage := 1

@onready var player_detector := $PlayerDetector
@onready var cooldown := $AttackCooldown

var player: Node2D = null

func _ready() -> void:
	player_detector.area_entered.connect(_on_playerdetector_area_entered)
	player_detector.area_exited.connect(_on_playerdetector_area_exited)

func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			handle_idle()
		State.CHASE:
			handle_chase()
		State.ATTACK:
			handle_attack()
		State.DEATH:
			handle_death()
	

func handle_idle():
	if player != null:
		current_state = State.CHASE
	
	# Idle Animation
	
func handle_chase():
	if player == null:
		current_state = State.IDLE
		return
	
	velocity = movement()
	# Walk animation
	move_and_slide()

func handle_attack():
	if cooldown.time_left > 0:
		return
	if player == null:
		current_state = State.IDLE
		return
	
	# Play Attack Animation
	# Deal Damage Logic Here
	print("Enemy attacks!")
	
	cooldown.start()
	current_state = State.CHASE

func handle_death():
	velocity = Vector2.ZERO
	# Play death animation here
	queue_free()


func movement() -> Vector2:
	var direction_to_player: Vector2 = (player.position - self.position).normalized()
	return direction_to_player * speed


# -------------------------------------------------------- #
# -------------------------------------------------------- #
# -------------------------------------------------------- #


func _on_playerdetector_area_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_playerdetector_area_exited(body: Node2D) -> void:
	if body == player:
		player = null
