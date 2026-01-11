extends CharacterBody2D
class_name Enemy_Class

@export var stats: EnemyStats

@onready var NoiseCollider: CollisionShape2D = $NoiseArea/CollisionShape2D
@onready var noise_area: Area2D = $NoiseArea
@onready var sprite_soundwave: Sprite2D = $SpriteSoundwave


var initial_movement_speed: float
var remaining_stun_duration: float
var remaining_slow_duration: float

var can_interact: bool = false

func initiate(_stats) -> void:
	stats = _stats
	var circle = NoiseCollider.shape as CircleShape2D
	circle.radius = stats.loudness * 100
	initial_movement_speed = stats.speed
	if stats.ability != null:
		stats.ability.initialize_ability(self)
	else:
		print("Stats are null!")
	
	sprite_soundwave.scale *= stats.loudness*1.5
	

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
	
	sprite_soundwave.visible = true
	await get_tree().create_timer(0.1).timeout
	sprite_soundwave.visible = false
	
	

func take_damage(amount: float) -> void:
	stats.HP -= amount
	if stats.HP <= 0:
		get_tree().current_scene.playerMoney += stats.money
		var money_gain_audio : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		money_gain_audio.stream = preload("res://Sounds/gaining money sound.wav")
		#money_gain_audio.volume_db = -10
		money_gain_audio.autoplay = true
		get_tree().current_scene.add_child(money_gain_audio)
		
		get_tree().current_scene.enemyAlive -= 1
		#if get_tree().current_scene.enemyAlive <= 0:

		get_parent().queue_free()
	
func apply_slow(duration: float, slow_percentage: float) -> void:
	remaining_slow_duration = duration
	stats.speed = stats.speed * (1.0 - (slow_percentage/100.0))

func apply_stun(duration: float) -> void:
	remaining_stun_duration = duration
	
func interact() -> void:
	print("Get stunned idiot!")
	apply_slow(3, 100)
	
	stats.speed=0
