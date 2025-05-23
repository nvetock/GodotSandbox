extends Node2D

### TODO: Add an array of items to be randomly selected and spawned

### TODO: Once enemies are created this could potentially be generic enough to be utilized by all things
### including mob hostility - maybe the 'arena' space is decoupled and emits signals instead


var can_spawn: bool = false
@export var spawn_time_delay: float = 5.0

var ItemScene = preload("res://entities/pickups/item_godot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(player_enter_arena)
	$Area2D.body_exited.connect(player_exit_arena)

func spawner() -> void:
	while can_spawn:
		await get_tree().create_timer(spawn_time_delay).timeout
		## Verify player is still inside the arena before spawning anything
		if not can_spawn:
			break
		
		var item := ItemScene.instantiate()
		
		var spawn_area: Vector2 = ($Area2D/CollisionShape2D.shape as RectangleShape2D).get_size()
		item.global_position = find_random_spawn_location(spawn_area)
		
		get_parent().add_child(item)
		await get_tree().create_timer(spawn_time_delay).timeout
		#item.global_position = Vector2

func find_random_spawn_location(totalArea: Vector2) -> Vector2:
	'''
	var top_left_vertex: Vector2 = Vector2(totalArea.x * 0.5, totalArea.y * 0.5)
	var bot_right_vertex: Vector2 = Vector2(totalArea.x, totalArea.y)
	'''
	
	var top_left_vertex := -totalArea * 0.5
	var bot_right_vertex := totalArea * 0.5
	
	var random_x_spawn = randf_range(top_left_vertex.x, bot_right_vertex.x)
	var random_y_spawn = randf_range(top_left_vertex.y, bot_right_vertex.y)
	
	return global_position + Vector2(random_x_spawn, random_y_spawn)


func player_enter_arena(other: Node2D) -> void:
	if other.is_in_group("player"):
		can_spawn = true
		spawner()

func player_exit_arena(other: Node2D) -> void:
	if other.is_in_group("player"):
		can_spawn = false
