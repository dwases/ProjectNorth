extends AnimatedSprite2D



func _ready() -> void:
	visible = true
	play("default")
	animation_finished.connect(_on_finished)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_finished():
	queue_free()
