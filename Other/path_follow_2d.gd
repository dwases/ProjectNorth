extends PathFollow2D
@export var speed: float = 500.0
@export var step_distance: float = 250.0
@export var loudness: int = 10
@export var hp: float = 100
@export var footsprite: PackedScene

@onready var enemy: Enemy_Class = $Enemy

var distance_progress: float = 0
var foot_flag: bool = false

func _ready():
	enemy.initiate()

func _physics_process(delta: float) -> void:
	if progress_ratio == 1:
		GameInstance.damage_player(1)
		self.queue_free()
	progress += speed * delta
	distance_progress += speed * delta
	
	if distance_progress >= step_distance:
		distance_progress = 0
		spawn_footstep()
		enemy.make_noise()
		
func spawn_footstep():
	var fs = footsprite.instantiate() as AnimatedSprite2D
	get_tree().current_scene.add_child(fs)
	fs.global_position = enemy.global_position
	fs.global_rotation = enemy.global_rotation + deg_to_rad(90)
	if foot_flag:
		fs.play("right")
		foot_flag = false
		fs.global_position = to_global(Vector2(0,10))
	else:
		fs.play("left")
		foot_flag = true
		fs.global_position = to_global(Vector2(0,-10))
	
	
