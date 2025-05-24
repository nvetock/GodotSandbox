extends Node

var items_collected: int = 0
var _player_health: int = 4
var is_game_paused: bool = false


### SIGNALS FOR OTHERS TO CONNECT TO
signal item_collected
signal player_died
signal reset_game


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func register_item(item: Node):
	# register item takes in the item as a node.
	# It then sets the instance's signal to connect to Game Managers _on_item_connected function
	
	item.collected.connect(_on_item_collected)
	
	# When item's collected() signal is called it will be triggering Game Managers function to call in response

func get_player_health() -> int:
	return _player_health

func reset_game_state() -> void:
	items_collected = 0
	_player_health = 3

func game_over() -> void:
	player_died.emit()
	pass




# -------------------------------------------------------- #
# ------------------ SIGNAL EVENTS ----------------------- #
# -------------------------------------------------------- #

func _on_item_collected(value: int):
	items_collected += value
	print("Item collected. Current total: " + str(items_collected))
