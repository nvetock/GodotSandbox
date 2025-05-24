extends Node
class_name HealthComponent

@export var max_health := 4
var current_health := max_health

signal died
signal health_changed(new_health: int)

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	#current_health = clamp(current_health - amount, 0, max_health)
	current_health -= amount
	health_changed.emit(current_health)
	
	if current_health <= 0:
		died.emit()

func heal(amount: int) -> void:
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit(current_health)

func is_alive() -> bool:
	return current_health > 0
