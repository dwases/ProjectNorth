extends EnemyAbility
class_name BeaconAbility

@export var timerInterval: int = 1
@export var repeat: int = 5

func initialize_ability(enemy: Node2D):
	for i in range(repeat):
		await(enemy.get_tree().create_timer(timerInterval).timeout)
		if enemy:
			(enemy as Enemy_Class).make_noise()
		else:
			break
	enemy.queue_free()
