extends StaticBody2D
class_name Tower

@export var stats: TowerStats
var targets_in_range: Array[Node2D] = []

func get_best_target() -> Node2D:
	if targets_in_range.is_empty():
		return null
	
	targets_in_range.sort_custom(func(a, b):
		if a.loudness != b.loudness:
			return a.loudness > b.loudness
		return a.progress > b.progress
	)
	return targets_in_range[0]
var can_shoot = true

func _process(delta):
	var target = get_best_target()
	if target and can_shoot:
		shoot(target)

func shoot(target):
	can_shoot = false
	$ReloadTimer.wait_time = 1.0 / stats.Attack_speed 
	$ReloadTimer.start()
	print("Strzelam")

func _on_reload_timer_timeout():
	can_shoot = true

func hear_enemy(enemy):
	if not targets_in_range.has(enemy):
		targets_in_range.append(enemy)
	await get_tree().create_timer(1.1).timeout 
	if is_instance_valid(enemy) and targets_in_range.has(enemy):
		targets_in_range.erase(enemy)
