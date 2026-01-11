extends EnemyAbility
class_name MajorAbility

@export var timerInterval: float = 30
@export var timerVariety: float = 0.3
@export var uses: int = 2
@export var throwRange: float = 200

var enemyClass = preload("res://Enemy/enemy_base.tscn")
var stats: EnemyStats = preload("res://Enemy/Resources/beacon_enemy_stats.tres")

func initialize_ability(enemy: Node2D):
	for i in range(uses):
		await(enemy.get_tree().create_timer(
			timerInterval * randf_range(1-timerVariety, 1+timerVariety)
			).timeout)
		if enemy:
			# Udana interakcja - Zespownij wabik
			var e = enemyClass.instantiate() as Enemy_Class
			e.stats = stats.duplicate(true) as EnemyStats
			var dist = randf_range(-throwRange, throwRange)
			var angle = randf_range(0, 2*PI)
			var offset = Vector2(throwRange, 0).rotated(angle)
			e.transform.origin = enemy.transform.origin + offset
			enemy.get_tree().current_scene.add_child(e)
			e.initiate(stats)
		else:
			break
	enemy.queue_free()
