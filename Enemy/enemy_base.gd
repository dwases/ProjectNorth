extends CharacterBody2D
class_name Enemy_Class

@export var stats: EnemyStats

@onready var NoiseCollider: CollisionShape2D = $NoiseArea/CollisionShape2D
@onready var noise_area: Area2D = $NoiseArea


func initiate() -> void:
	var circle = NoiseCollider.shape as CircleShape2D
	circle.radius = stats.loudness * 100
	
func make_noise() -> void:
	if noise_area.has_overlapping_bodies():
		var TowerArray = noise_area.get_overlapping_bodies()
		for tower in TowerArray:
			tower.hear_enemy(self)

func take_damage(amount: float) -> void:
	stats.HP -= amount
	if stats.HP <= 0:
		get_parent().queue_free()
	
	
