extends Area2D

@export var player_speed = 40
@export var player_sprint = 60

var is_sprinting: bool = false

# last_dir holds the last called direction to maintain the facing direction when movement stops
var last_dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += move(player_speed, player_sprint, delta)

func get_input() -> Vector2:
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return dir.normalized()

func get_sprint() -> int:
	is_sprinting = Input.is_action_pressed("sprint")
	return int(is_sprinting)

func set_animation(dir: Vector2) -> void:
	var s = "idle"
	if dir.length() > 0.1:
		if is_sprinting:
			s = "run"
		else:
			s = "walk"
	else:
		s = "idle"
	
	if last_dir == Vector2.LEFT:
		$AnimatedSprite2D.animation = s + "_left"
	elif last_dir == Vector2.RIGHT:
		$AnimatedSprite2D.animation = s + "_right"
	elif last_dir == Vector2.UP:
		$AnimatedSprite2D.animation = s + "_up"
	elif last_dir == Vector2.DOWN:
		$AnimatedSprite2D.animation = s + "_down"
	
	$AnimatedSprite2D.play()

func move(speed: int, sprint_speed: int, delta: float) -> Vector2:
	var dir: Vector2 = get_input()
	var desired_move: Vector2 = Vector2.ZERO
	
	var sprint_multi = get_sprint()
	
	# If input magnitude is greater than 0.1 then move the character
	if dir.length() > 0.1:
		last_dir = dir
		var move_speed = speed + (sprint_multi * sprint_speed)
		
		desired_move += dir * move_speed * delta
	else:
		desired_move = Vector2.ZERO
		
	set_animation(dir)
	return desired_move
