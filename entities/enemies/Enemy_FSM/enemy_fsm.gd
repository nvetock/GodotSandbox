extends CharacterBody2D

@export var speed := 60

var curr_velocity: Vector2 = Vector2.ZERO
var player: Node2D = null

var states: Dictionary = {}
var current_state: BaseState

@onready var attack_cooldown := $AttackCooldown
@onready var health := $HealthComponent
@onready var attack_radius := $AttackDetector
@onready var player_detect_radius := $PlayerDetector


func _ready():
	#Load states
	states["idle"] = preload("res://experiments/fsm/IdleState.gd").new()
	states["chase"] = preload("res://experiments/fsm/ChaseState.gd").new()
	states["attack"] = preload("res://experiments/fsm/AttackState.gd").new()
	states["death"] = preload("res://experiments/fsm/DeathState.gd").new()
	
	health.died.connect(_on_died)
	$AttackDetector.body_entered.connect(_on_player_enter_attack_area)
	$AttackDetector.body_exited.connect(_on_player_exit_attack_area)
	$PlayerDetector.body_entered.connect(_on_player_enter_detect_area)
	$PlayerDetector.body_exited.connect(_on_player_exit_detect_area)
	
	change_state("idle")

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update(self, delta)

func change_state(state_name: String):
	if current_state:
		current_state.exit(self)
	
	current_state = states.get(state_name)
	if current_state:
		current_state.enter(self)

func can_see_player() -> bool:
	#if not player:
	#	#player = get_tree().get_root().find_node("Player", true, false)
	#	player = get_tree().get_first_node_in_group("player")
	#
	#if not player:
	#	return false
	#
	#return global_position.distance_to(player.global_position) < 100
	return player != null

func _on_player_enter_detect_area(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_player_exit_detect_area(body: Node2D) -> void:
	if body == player:
		player = null

func _on_player_enter_attack_area(body: Node2D) -> void:
	if body.is_in_group("player"):
		change_state("attack")

func _on_player_exit_attack_area(body: Node2D) -> void:
	if body == player:
		change_state("chase")

# -------------------------------------------------------- #
# ------------------ SIGNAL EVENTS ----------------------- #
# -------------------------------------------------------- #

func _on_died():
	change_state("dead")
