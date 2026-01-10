extends CharacterBody2D
class_name Enemy_Class

@export var stats: EnemyStats

@onready var NoiseCollider: CollisionShape2D = $NoiseArea/CollisionShape2D
@onready var noise_area: Area2D = $NoiseArea

var initial_movement_speed: float
var remaining_stun_duration: float
var remaining_slow_duration: float

func initiate() -> void:
	var circle = NoiseCollider.shape as CircleShape2D
	circle.radius = stats.loudness * 100
	
func _ready() -> void:
	initial_movement_speed = stats.speed

func _process(delta: float) -> void:
	if remaining_slow_duration <= 0 and remaining_stun_duration <= 0:
		stats.speed = initial_movement_speed
	remaining_slow_duration = remaining_slow_duration - delta
	remaining_stun_duration = remaining_slow_duration - delta
	

func make_noise() -> void:
	if noise_area.has_overlapping_bodies():
		var TowerArray = noise_area.get_overlapping_bodies()
		for tower in TowerArray:
			tower.hear_enemy(self)

func take_damage(amount: float) -> void:
	stats.HP -= amount
	if stats.HP <= 0:
		get_parent().queue_free()
	
func apply_slow(duration: float, slow_percentage: float) -> void:
	remaining_slow_duration = duration
	stats.speed = stats.speed * (1.0 - (slow_percentage/100.0))

func apply_stun(duration: float) -> void:
	remaining_stun_duration = duration
	
