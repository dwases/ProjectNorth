extends PathFollow2D
@export var speed: float = 500.0
@export var step_distance: float = 250.0
@export var loudness: int = 10
@export var hp: int = 100
@export var footsprite: PackedScene

@onready var enemy: CharacterBody2D = $Enemy


var distance_progress: float = 0

func _ready() -> void:
	
	pass
	

func _physics_process(delta: float) -> void:
	progress += speed * delta
	distance_progress += speed * delta
	if distance_progress >= step_distance:
		distance_progress = 0
		
