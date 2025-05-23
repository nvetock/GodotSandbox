extends Area2D

signal collected(value: int) #

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	GameManager.register_item(self) # This object registers itself into GameManager's awareness through a register_item function


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		collected.emit(1)
		queue_free()
		
		hide()
