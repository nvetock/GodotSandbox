extends CanvasLayer

var health_icons_paths: Array[String] = [
	"res://resources/ui/health_0.png",
	"res://resources/ui/health_1.png",
	"res://resources/ui/health_2.png",
	"res://resources/ui/health_3.png",
	"res://resources/ui/health_4.png"
]

var health_icons: Array[Texture2D] = []

@onready var _max_health: int = GameManager.get_player_health()
@onready var player := get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#player = get_tree().get_first_node_in_group("player")
	print(player.get_node("HealthComponent").current_health)
	print(player.get_node("HealthComponent").current_health)
	print(player.get_node("HealthComponent").current_health)
	print(player.get_node("HealthComponent").current_health)
	print(player)
	print(player)
	_max_health = GameManager.get_player_health()
	
	for path in health_icons_paths:
		health_icons.append(load(path) as Texture2D)
	
	player.get_node("HealthComponent").health_changed.connect(update_health_icon)
	
	update_health_icon(_max_health)
	
	#GameManager.health_changed.connect(update_health_icon)
	
	# connect a signal listener for player being damaged

func _process(delta: float) -> void:
	pass


func update_health_icon(health: int) -> void:
	$HealthSprite.texture = health_icons[clamp(health, 0, _max_health)]
