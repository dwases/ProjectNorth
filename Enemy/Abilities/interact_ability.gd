extends EnemyAbility
class_name InteractAbility

func initialize_ability(enemy: Node2D):
	enemy.can_interact = true

func interact(otherObj: Node2D):
	if otherObj.has_method("interact"):
		otherObj.interact()
