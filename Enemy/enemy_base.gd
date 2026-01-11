extends CharacterBody2D
class_name Enemy_Class

@export var stats: EnemyStats
@onready var hp_bar = $TextureProgressBar
@onready var NoiseCollider: CollisionShape2D = $NoiseArea/CollisionShape2D
@onready var noise_area: Area2D = $NoiseArea
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sprite_soundwave: Sprite2D = $SpriteSoundwave
var active_tags: Dictionary = {}

var initial_movement_speed: float
var remaining_stun_duration: float
var remaining_slow_duration: float
var HP: float=10
func _ready() -> void:
	HP = float(stats.Base_HP)*pow(1.2, get_tree().current_scene.wave-1)
	$SpriteSoundwave.scale = Vector2(0.2,0.2)
	hp_bar.max_value = int(HP)
	hp_bar.value = int(HP)
	
var remaining_soundwave_duration: float

var can_interact: bool = false


func initiate(_stats) -> void:
	stats = _stats
	var circle = NoiseCollider.shape as CircleShape2D
	circle.radius = stats.loudness * 55
	initial_movement_speed = stats.speed
	if stats.ability != null:
		stats.ability.initialize_ability(self)
	else:
		print("Stats are null!")
	if stats.loudness == 3:
		point_light_2d.color = Color(0.0, 1.0, 0.0, 0.8)
	elif stats.loudness == 4:
		point_light_2d.color = Color(1.0, 1.0, 0.0, 1.0)
	elif stats.loudness == 6:
		point_light_2d.color = Color(1.0, 0.498, 0.0, 1.0)
	elif stats.loudness == 7:
		point_light_2d.color = Color(0.944, 0.085, 0.0, 1.0)
	
	#sprite_soundwave.scale *= stats.loudness*0.2
	
	

func _process(delta: float) -> void:
	if remaining_slow_duration <= Time.get_ticks_msec():
		stats.speed = initial_movement_speed
		active_tags.erase("frozen")
		owner.stats.speed = stats.speed


func make_noise() -> void:
	if noise_area.has_overlapping_bodies():
		var TowerArray = noise_area.get_overlapping_bodies()
		for tower in TowerArray:
			tower.hear_enemy(self)
	
	
	var t := create_tween()
	t.tween_property($SpriteSoundwave, "scale", Vector2(stats.loudness*2, stats.loudness*2), 0.3)
	#
	remaining_soundwave_duration = 0.3
	sprite_soundwave.visible = true
	#
	await t.finished
	sprite_soundwave.scale = Vector2(0.2,0.2)


func take_damage(amount: float) -> void:
	HP -= amount
	hp_bar.value = int(HP)
	if HP <= 0:
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
	remaining_slow_duration = Time.get_ticks_msec() + duration*1000
	stats.speed = stats.speed * (1.0 - (slow_percentage/100.0))
	print(stats.speed)
	owner.stats.speed = stats.speed
	active_tags["frozen"] = true

func apply_stun(duration: float) -> void:
	remaining_stun_duration = duration
	
func interact() -> void:
	print("Get stunned idiot!")
	apply_slow(3, 100)
	
	stats.speed=0
