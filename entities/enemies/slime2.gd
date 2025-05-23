extends Area2D

@export var speed: int = 85
@export var debug_dir: Vector2

var player: Node2D = null
var last_dir: Vector2 = Vector2.ZERO

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

# Slime always knows about player
# Slime will slowly jump toward player
# When player is in range, jumping will speed up
# When player is in hit range, attack triggers
# Slime died after attack




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
