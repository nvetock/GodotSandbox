# experiments/fsm/BaseState.gd
# Interface that other states inherit from


extends Resource

class_name BaseState

func enter(owner: Node) -> void:
	pass

func update(owner: Node, delta: float) -> void:
	pass

func exit(owner: Node) -> void:
	pass
