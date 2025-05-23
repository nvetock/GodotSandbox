extends CharacterBody2D

@export var player_speed: int = 150
@export var player_sprint: int = 150


var direction_to_move: Vector2 = Vector2.ZERO
# last_facing_direction holds the last called direction to maintain the facing direction when movement stops
var last_facing_direction: Vector2 = Vector2.ZERO

var is_sprinting: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_facing_direction = Vector2.DOWN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction_to_move = get_input()
	
	if direction_to_move.length() > 0.1:
		last_facing_direction = direction_to_move
		
		''' IF CARDINAL SNAPPING IS DESIRED
		if abs(direction_to_move.x) > abs(direction_to_move.y):
			direction_to_move = Vector2.RIGHT if direction_to_move.x > 0 else Vector2.LEFT
		else:
			direction_to_move = Vector2.DOWN if direction_to_move.y > 0 else Vector2.UP
		'''
	
	update_animation(direction_to_move, is_sprinting)

func _physics_process(delta: float) -> void:
	velocity = fixed_move(direction_to_move, player_speed + (player_sprint * get_sprint()))
	move_and_slide()


func get_input() -> Vector2:
	var dir: Vector2 = Vector2.ZERO
	dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	return dir.normalized()

func get_sprint() -> int:
	is_sprinting = Input.is_action_pressed("sprint")
	return int(is_sprinting)

func fixed_move(direction: Vector2, speed: int) -> Vector2:
	return direction_to_move * speed


#### ANIMATION LOGIC
func get_animation_prefix(direction: Vector2, is_sprint: bool) -> String:
	if direction.length() > 0.1:
		return "walk" if not is_sprint else "run"
	else:
		return "idle"

func get_animation_suffix(direction: Vector2) -> String:
	if abs(last_facing_direction.x) > abs(last_facing_direction.y):
		return "_right" if last_facing_direction.x > 0 else "_left"
	else:
		return "_down" if last_facing_direction.y > 0 else "_up"

func update_animation(direction: Vector2, sprint_toggle: bool) -> void:
	
	var anim_prefix = get_animation_prefix(direction, sprint_toggle)
	var anim_suffix = get_animation_suffix(direction)
	
	$AnimatedSprite2D.animation = anim_prefix + anim_suffix
	$AnimatedSprite2D.play()
