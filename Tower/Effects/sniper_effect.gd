extends TowerEffect
class_name SniperEffect

@export var damage_multiplier: float = 0.1
@export var min_damage: float = 10
@export var min_damage_range: float = 100

func apply_effect(enemy: Node2D, tower: Node2D):
	var distance = enemy.global_position.distance_to(tower.global_position)
	if enemy.has_method("take_damage"):
		var sniper_damage = distance * damage_multiplier if (distance >= min_damage_range) else min_damage
		enemy.take_damage(sniper_damage)
