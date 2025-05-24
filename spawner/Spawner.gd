extends Node2D

##### PROPERTIES


## Delegates if this spawner is random or has defined spawn locations
@export var random_spawn: bool = false

## Time delay in seconds between spawning
@export var spawn_time_delay: float = 5.0

@export var spawnables: Array[PackedScene] = []
var can_spawn: bool = false

## Safeguard to prevent overlapping spawner calls
var is_spawning: bool = false


##### ENUM

## Defines spawn method.
## - Practice is individual light units.
## - Wave expects a set number of rounds and ends with a boss fight.
## - Boss is an individual boss.
## - Chaos is waves of randomized boss and light units.
enum SpawnMode { PRACTICE, WAVE, BOSS, CHAOS }






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.arena_entered.connect(_on_arena_enter)
	EventManager.arena_exited.connect(_on_arena_exit)


func spawner() -> void:
	while can_spawn:
		await get_tree().create_timer(spawn_time_delay).timeout
		
		if spawnables.size() == 0:
			push_warning("Spawner has no assigned spawnables.")
			return
		
		if random_spawn:
			
			var spawn_area: Vector2 = ($Area2D/CollisionShape2D.shape as RectangleShape2D).get_size()
			#item.global_position = find_random_spawn_location(spawn_area)
			
		
		#get_parent().add_child(item)
		#item.global_position = Vector2

## Finds a random spawn location based on the area defined by the scene's Area2D node
##
## @param totalArea: The shape's size as a Vector2
func find_random_spawn_location(totalArea: Vector2) -> Vector2:
	var top_left_vertex := -totalArea * 0.5
	var top_mid_vertex := Vector2(top_left_vertex.x + (totalArea.x / 2), top_left_vertex.y)
	var bot_right_vertex := totalArea * 0.5
	
	var random_x_spawn = randf_range(top_mid_vertex.x, bot_right_vertex.x)
	var random_y_spawn = randf_range(top_mid_vertex.y, bot_right_vertex.y)
	
	return global_position + Vector2(random_x_spawn, random_y_spawn)

## Takes a player's choice of spawn set and reads from the "enemy_sets" json file
## To load in all selected enemies into the spawnables before spawning.
## This method should be called by an external script that allows player to choose
func load_spawnables_from_set(dataset_name: String) -> bool:
	var file := FileAccess.open("res://data/enemy_sets.json", FileAccess.READ)
	
	if file == null:
		push_error("Could not open enemy_sets.json")
		return false
	
	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		push_error("Malformed JSON")
		return false
	
	if not data.has(dataset_name):
		push_warning("Enemy set '%s' not found in JSON" % dataset_name)
		return false
	
	var paths: Array = data[dataset_name]
	spawnables.clear()
	
	for path in paths:
		var scene: PackedScene = load(path)
		if scene != null:
			spawnables.append(scene)
		else:
			push_warning("Could not load scene at: " + path)
	
	return true

### Spawner logic

func _on_arena_enter() -> void:
	if not is_spawning:
		can_spawn = true
		is_spawning = true
		await spawner()
		is_spawning = false

func _on_arena_exit() -> void:
	# Kill any processes running spawn logic
	can_spawn = false
	pass
