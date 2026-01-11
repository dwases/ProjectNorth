extends TowerEffect
class_name ExplosionEffect

@export var explosion_range: float = 100
@export var damage_falloff: float = 0.5

func apply_effect(enemy: Node2D, tower: Node2D):
	# Get other enemies in range...
	var space_state = enemy.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	
	var shape = CircleShape2D.new()
	shape.radius = explosion_range
	query.shape = shape
	
	query.transform = Transform2D(0, enemy.global_position)
	query.collision_mask = 2
	
	var query_result = space_state.intersect_shape(query)
	var nodes = []
	for node in query_result:
		nodes.append(node.collider)
	
	
	for node in nodes:
		if node.has_method("take_damage"):
			var dist = node.global_position.distance_to(enemy.global_position)
			if dist > explosion_range:
				continue
			var damage = tower.stats.Damage - dist / explosion_range * tower.stats.Damage * damage_falloff
			node.take_damage(damage)
