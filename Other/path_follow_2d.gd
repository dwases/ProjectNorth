extends PathFollow2D
@export var speed: float = 500.0
@export var step_distance: float = 250.0
@export var loudness: int = 10
@export var hp: int = 100
@export var footsprite: PackedScene

@onready var enemy: CharacterBody2D = $Enemy

var distance_progress: float = 0
var foot_flag: bool = false

func _physics_process(delta: float) -> void:
	progress += speed * delta
	distance_progress += speed * delta
	
	if distance_progress >= step_distance:
		distance_progress = 0
		spawn_footstep()
		
func spawn_footstep():
	var fs = footsprite.instantiate() as AnimatedSprite2D
	get_tree().current_scene.add_child(fs)
	if foot_flag:
		fs.play("right")
		foot_flag = false
	else:
		fs.play("left")
		foot_flag = true
	fs.global_position = enemy.global_position
	fs.global_rotation = enemy.global_rotation + 90
	
	
