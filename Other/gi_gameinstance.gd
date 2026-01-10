extends Node
class_name GI_GameInstace

var playerHP: int = 10


var main_camera: Camera2D
var cameraShakeNoise: FastNoiseLite

func _ready() -> void:
	cameraShakeNoise = FastNoiseLite.new()
	main_camera = get_node("/root/MainMap1/Camera2D")

func damage_player(value: int) -> void:
	playerHP -= value
	
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(StartShakingCamera, 5.0, 1.0, 1.0)
	if playerHP <= 0:
		print("Gracz nie zyje")

func StartShakingCamera(intensity: float):
	var cameraOffset = cameraShakeNoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	main_camera.offset.x = cameraOffset * randf_range(0.9,3.5)
	main_camera.offset.y = cameraOffset * randf_range(0.9,3.5)
