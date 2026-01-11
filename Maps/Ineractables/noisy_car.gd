extends Node2D

@onready var timer: Timer = $Timer
var enemyClass = preload("res://Enemy/enemy_base.tscn")

@export var stats: EnemyStats
var lastKnownBody: Node2D
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.can_interact:
		if timer.is_stopped():
			
			# Jeżeli nikt nie interaktuje - rozpocznij interakcję
			body.interact()
			lastKnownBody = body
			timer.start()

func _on_timer_timeout() -> void:
	if lastKnownBody:
		print("KABOOM")
		
		# Udana interakcja - Zespownij wabik
		var e = enemyClass.instantiate() as Enemy_Class
		e.stats = stats.duplicate(true) as EnemyStats
		e.transform.origin = transform.origin
		get_tree().current_scene.add_child(e)
		e.initiate(stats)
		
		# Usuń samochód
		queue_free()
	else:
		timer.wait_time = 3

func _process(delta: float) -> void:
	if !lastKnownBody:
		timer.stop()
		timer.wait_time = 3
