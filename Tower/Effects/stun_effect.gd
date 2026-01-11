extends TowerEffect
class_name StunEffect

@export var stun_chance: float = 0.1
@export var duration: float = 1.0

func apply_effect(enemy: Node2D, tower: Node2D):
	if randf() <= stun_chance:
		if enemy.has_method("apply_stun"):
			enemy.apply_stun(duration)
