extends CharacterBody2D

@export var move_speed: int = 85
@export var find_target_delay: float = 1.0
@export var movement_delay: float = 2.5
@export var explosion_delay: float = 1.0

var last_dir: Vector2 = Vector2.ZERO


var last_target_location: Vector2 = Vector2.ZERO

@onready var player := get_tree().get_first_node_in_group("player")

var chase_mode: bool = true
var attack_mode: bool = false


func _ready() -> void:
	$DetectRadius.area_entered.connect(trigger_explosion)
	move_to_target(last_target_location, move_speed)

func _process(delta: float) -> void:
	update_animation()

func _physics_process(delta: float) -> void:
	move_and_slide()



func direction_to_target(target: Node2D) -> Vector2:
	return (target.position - self.position).normalized()

func move_to_target(direction: Vector2, speed: int) -> void:
	while chase_mode:
		velocity = Vector2.ZERO
		last_target_location = direction_to_target(player)
		await get_tree().create_timer(find_target_delay).timeout
		
		last_dir = last_target_location
		velocity = last_target_location * move_speed
		
		await get_tree().create_timer(movement_delay).timeout


func trigger_explosion() -> void:
	chase_mode = false
	attack_mode = true
	
	velocity = Vector2.ZERO
	#$AnimatedSprite2D.stop()
	await get_tree().create_timer(explosion_delay).timeout
	
	#$AnimatedSprite2D.play()
	death()
	#$AnimatedSprite2D.animation = "attack" + get_animation_suffix(last_dir)

func death() -> void:
	print("Death Initiated")
	queue_free()
	hide()


##### ANIMATION

func get_animation_prefix(direction_to_move: Vector2) -> String:
	if not attack_mode:
		if direction_to_move.length() > 0.1:
			return "walk"
		
		return "idle"
		
	elif attack_mode:
		return "attack"
		
	else:
		return "death"

func get_animation_suffix(direction_to_move: Vector2) -> String:
	if abs(direction_to_move.x) > abs(direction_to_move.y):
		return "_right" if last_dir.x > 0 else "_left"
	else:
		return "_down" if last_dir.y > 0 else "_up"

func update_animation() -> void:
	var anim := get_animation_prefix(velocity) + get_animation_suffix(last_dir)
	$AnimatedSprite2D.animation = anim
	
	$AnimatedSprite2D.play()


'''
func _ready():
	$DetectRadius.area_entered.connect(_on_DetectRadius_area_entered)
	$DetectRadius.area_exited.connect(_on_DetectRadius_area_exited)
	player = get_tree().
	
	
func _process(delta: float) -> void:
	if player != null:
		var direction = (player.position - position).normalized()
		if direction.length() > 0.1:
			last_dir = direction
		position += direction * speed * delta
		update_animation(direction)
	else:
		update_animation(Vector2.ZERO)






func move_towards_player():
	





func update_animation(direction: Vector2) -> void:
	var anim_prefix = "idle"
	if direction.length() > 0.1:
		anim_prefix = "walk"

	var anim_suffix = get_direction_suffix(last_dir)
	$AnimatedSprite2D.animation = anim_prefix + anim_suffix
	$AnimatedSprite2D.play()

func get_direction_suffix(dir: Vector2) -> String:
	if abs(dir.x) > abs(dir.y):
		return "_right" if dir.x > 0 else "_left"
	else:
		return "_down" if dir.y > 0 else "_up"

func _on_DetectRadius_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		player = area

func _on_DetectRadius_area_exited(area: Area2D) -> void:
	if area == player:
		player = null
'''
