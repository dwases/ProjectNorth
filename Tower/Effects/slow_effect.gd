extends TowerEffect
class_name SlowEffect

@export var slow_percent: float = 0.4
@export var duration: float = 1.0

func is_valid_target(enemy: Node) -> bool:
	return not enemy.active_tags.has("frozen")

func apply_effect(enemy: Node2D):
	if enemy.has_method("apply_slow"):
		enemy.apply_slow(slow_percent, duration)
