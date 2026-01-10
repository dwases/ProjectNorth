extends Node

@onready var timer: Timer = $Timer
var lastKnownBody: Node2D = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.can_interact:
		if timer.is_stopped():
			body.interact()
			lastKnownBody = body
			timer.start()

func _on_timer_timeout() -> void:
	if lastKnownBody:
		print("KABOOM")
		queue_free()
	else:
		timer.wait_time = 3
