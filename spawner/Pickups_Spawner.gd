extends Node2D

"""
Currently uses the same code as Spawner. Might need to be less tuned to enemies and work as a child node of Arena.
"""


##### PROPERTIES


## Delegates if this spawner is random or has defined spawn locations
@export var random_spawn: bool = false

## Time delay in seconds between spawning
@export var spawn_time_delay: float = 5.0

# replace this
var spawnables = preload("res://entities/pickups/item_godot.tscn")
var can_spawn: bool = false


##### ENUM

enum SpawnMode { HEALTH, POWERUP, COIN, ITEM }






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.arena_entered.connect(_on_arena_enter)
	EventManager.arena_exited.connect(_on_arena_exit)


func spawner() -> void:
	while can_spawn:
		await get_tree().create_timer(spawn_time_delay).timeout
		
		var item := spawnables.instantiate()
		
		if random_spawn:
			var spawn_area: Vector2 = ($Area2D/CollisionShape2D.shape as RectangleShape2D).get_size()
			item.global_position = find_random_spawn_location(spawn_area)
		
		get_parent().add_child(item)
		#item.global_position = Vector2

## Finds a random spawn location based on the area defined by the scene's Area2D node
##
## @param totalArea: The shape's size as a Vector2
func find_random_spawn_location(totalArea: Vector2) -> Vector2:
	var top_left_vertex := -totalArea * 0.5
	var bot_right_vertex := totalArea * 0.5
	
	var random_x_spawn = randf_range(top_left_vertex.x, bot_right_vertex.x)
	var random_y_spawn = randf_range(top_left_vertex.y, bot_right_vertex.y)
	
	return global_position + Vector2(random_x_spawn, random_y_spawn)

func _on_arena_enter() -> void:
	can_spawn = true
	spawner()

func _on_arena_exit() -> void:
	# Kill any processes running spawn logic
	can_spawn = false
	pass
