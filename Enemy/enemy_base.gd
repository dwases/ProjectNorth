extends CharacterBody2D
class_name Enemy_Class

var speed: float = 500.0
var step_distance: float = 250.0
var loudness: int = 10
var hp: float = 100

@onready var NoiseCollider: CollisionShape2D = $NoiseArea/CollisionShape2D
@onready var noise_area: Area2D = $NoiseArea


func initiate(s: float, sd: float, l: int, _hp: float) -> void:
	speed = s
	step_distance = sd
	loudness = l
	hp = _hp
	var circle = NoiseCollider.shape as CircleShape2D
	circle.radius = l * 100
	
func make_noise() -> void:
	if noise_area.has_overlapping_bodies():
		var TowerArray = noise_area.get_overlapping_bodies()
		for tower in TowerArray:
			tower.hear_enemy(self)

func take_damage(amount: float) -> void:
	hp -= amount
	if hp <= 0:
		get_parent().queue_free()
	
	
