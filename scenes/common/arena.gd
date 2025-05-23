extends Node2D


# On player entering arena, arena should emit signal triggering:
# - Lock doors
# - initiate spawner with pre-defined enemy spawner request (sign??)
# - HUD appearance? health, items, powerups etc.
# 
# 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(player_enter_arena)
	$Area2D.body_exited.connect(player_exit_arena)


func player_enter_arena(other: Node2D) -> void:
	if other.is_in_group("player"):
		print("Arena Entered")
		EventManager.arena_entered.emit()

func player_exit_arena(other: Node2D) -> void:
	if other.is_in_group("player"):
		EventManager.arena_exited.emit()
		# Use if anything should happen when player exits arena..
		# - Trigger autosave?
		# - Trigger fight payment??
